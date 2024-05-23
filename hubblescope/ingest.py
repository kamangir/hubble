from hubblescope import NAME
from tqdm import tqdm
from abcli import file
from hubblescope.fits import load_fit_file
from abcli.modules import objects
from hubblescope.logger import logger


def ingest(
    object_name: str,
    dataset_name: str,
    hubble_object_name: str,
    plot: bool = False,
) -> bool:
    logger.info(
        "{}.ingest({} :: {} [{}])".format(
            NAME,
            dataset_name,
            object_name,
            hubble_object_name,
        )
    )

    if dataset_name in ["hst"]:
        logger.info("ingesting *fit")
        for filename in tqdm(objects.list_of_files(object_name)):
            if file.extension(filename) == "fits":
                load_fit_file(filename, plot=plot)

    return True
