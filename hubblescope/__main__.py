import argparse

from blueness.argparse.generic import sys_exit

from hubblescope.datasets import get
from hubblescope.ingest import ingest
from hubblescope import NAME, VERSION, DESCRIPTION, ICON
from hubblescope.logger import logger

parser = argparse.ArgumentParser(NAME)
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
    "--show_description",
    type=bool,
    default=0,
    help="0|1",
)
parser.add_argument(
    "--show_icon",
    type=int,
    default=0,
    help="0|1",
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
    print(
        "{}{}-{}{}".format(
            f"{ICON} " if args.show_icon else "",
            NAME,
            VERSION,
            "\\n{}".format(DESCRIPTION) if args.show_description else "",
        )
    )
    success = True
else:
    success = None

sys_exit(logger, NAME, args.task, success)
