from typing import Any
import os

from blue_options import string
from blue_objects import file
from blue_objects.env import abcli_path_git


# https://registry.opendata.aws/hst/
# https://github.com/awslabs/open-data-registry/blob/main/datasets/hst.yaml
def get(
    dataset_name: str,
    what: str,
    object_name: str = "",
) -> Any:
    if what == "auth":
        resources = get(dataset_name, "resource:S3 Bucket")
        if not resources:
            return "auth:resource-not-found"

        RequesterPays = resources[0].get("RequesterPays", False)

        return "--requester-pays" if RequesterPays else "--no-sign-request"

    if what == "metadata":
        return file.load_yaml(
            get(
                dataset_name,
                "metadata_filename",
            )
        )[1]

    if what == "metadata_filename":
        return os.path.join(
            abcli_path_git,
            f"open-data-registry/datasets/{dataset_name}.yaml",
        )

    if what.startswith("resource:"):
        resource_type = string.after(what, "resource:")

        metadata = get(dataset_name, "metadata")
        if not metadata:
            return [{"resource:metadata-not-found": True}]

        return [
            resource
            for resource in metadata.get("Resources", {})
            if resource.get("Type") == resource_type
        ]

    if what == "s3_uri":
        resources = get(dataset_name, "resource:S3 Bucket")
        if not resources:
            return "s3_uri:resource-not-found"

        ARN = resources[0].get("ARN", "")

        # arn:aws:s3:::stpubdata/hst
        return "s3://{}/{}".format(
            string.after(ARN, "arn:aws:s3:::"),
            f"{object_name}/" if object_name else "",
        )

    return f"{what}-not-found"
