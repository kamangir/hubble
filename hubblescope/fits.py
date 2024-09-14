import numpy as np
from typing import List
from astropy.io import fits
import matplotlib.pyplot as plt

from blue_objects import file, path
from blue_objects.graphics.gif import generate_animated_gif

from hubblescope import NAME
from hubblescope.logger import logger


def load_fit_file(
    filename: str,
    plot: bool = False,
    cmap: str = "hot",
) -> List[np.ndarray]:
    list_of_images = []
    with fits.open(filename) as hdul:
        hdul.info()
        logger.info(f"{NAME}.load_fit_file({filename}): {len(hdul)} item(s)")

        images = []
        first_to_show = True
        for index, item in enumerate(hdul):
            if item.data is None:
                logger.info(f"#{index}: Null")
                continue

            image = item.data
            logger.info(f"#{index}: {image.shape}")

            if len(image.shape) != 2:
                logger.info("skipped.")
                continue

            images += [image]

            margin = 5

            image_flattenned = image.flatten()
            image_flattenned = image_flattenned[~np.isnan(image_flattenned)]
            if not image_flattenned.shape:
                logger.warning("empty (likely all nan) image, skipped.")
                continue
            vmin = np.percentile(image_flattenned, margin)
            vmax = np.percentile(image_flattenned, 100 - margin)

            logger.info(f"#{index}: {vmin:.3f} - {vmax:.3f}")

            histogram, bin_edges = np.histogram(
                image_flattenned,
                bins=256,
                range=(vmin, vmax),
            )

            bins = (bin_edges[:-1] + bin_edges[1:]) / 2

            plt.figure(figsize=(10, 5))

            plt.subplot(121)
            plt.imshow(
                image,
                cmap=cmap,
                vmin=vmin,
                vmax=vmax,
            )
            plt.colorbar(cmap=cmap)
            plt.title(f"{file.name_and_extension(filename)}/{index}")
            plt.xlabel(path.name(file.path(filename)))

            plt.subplot(122)
            plt.plot(bins, histogram, color="b")
            plt.xlabel("value")
            plt.ylabel("frequency")
            plt.grid(True)
            image_filename = file.add_suffix(
                file.add_extension(filename, "png"),
                f"{index}",
            )
            plt.savefig(image_filename)
            list_of_images += [image_filename]
            if plot and first_to_show:
                first_to_show = False
                plt.show()
            else:
                plt.close()

        generate_animated_gif(
            list_of_images,
            file.add_extension(filename, "gif"),
            frame_duration=500,
        )

    return images
