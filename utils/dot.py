from pathlib import Path
from argparse import ArgumentParser, Namespace

args: Namespace = None


def __main():
    args = __define_arg_parser().parse_args()

    print(args.dotdir)


def __define_arg_parser() -> ArgumentParser:
    parser = ArgumentParser(prog="DotSync", description="Manages dotfiles symlink")

    parser.add_argument("-d", "--directory", default=Path.home() / ".dotfiles")
    parser.add_argument("-p", "--profile", default="all")

    return parser


def __get_files(dir: Path) -> list[Path]:
    paths = []
    if not dir.exists():
        return paths

    for p in dir.glob("*"):
        if p.is_dir():
            paths += __get_files(p)
        else:
            paths.append(p)

    return paths


if __name__ == "__main__":
    __main()
