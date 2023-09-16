import argparse
from hubble.datasets import get
from hubble.ingest import ingest
from hubble import NAME, VERSION
from abcli import logging
import logging

logger = logging.getLogger(__name__)

parser = argparse.ArgumentParser(NAME, description=f"{NAME}-{VERSION}")
parser.add_argument(
    "task",
    type=str,
    help="get|ingest|version",
)
parser.add_argument(
    "--dataset_name",
    type=str,
    default="",
)
parser.add_argument(
    "--object_name",
    type=str,
    default="",
)
parser.add_argument(
    "--hubble_object_name",
    type=str,
    default="",
)
parser.add_argument(
    "--what",
    type=str,
    default="",
)
args = parser.parse_args()

success = False
if args.task == "get":
    print(
        get(
            args.dataset_name,
            args.what,
            args.object_name,
        )
    )
    success = True
elif args.task == "ingest":
    success = ingest(
        args.object_name,
        args.dataset_name,
        args.hubble_object_name,
    )
elif args.task == "version":
    print(f"{NAME}-{VERSION}")
    success = True
else:
    logger.error(f"-{NAME}: {args.task}: command not found.")

if not success:
    logger.error(f"-{NAME}: {args.task}: failed.")
