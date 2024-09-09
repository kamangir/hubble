from tqdm import tqdm

from blueness import module
from blue_objects import file, objects

from hubblescope import NAME
from hubblescope.fits import load_fit_file
from hubblescope.logger import logger


NAME = module.name(__file__, NAME)


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
