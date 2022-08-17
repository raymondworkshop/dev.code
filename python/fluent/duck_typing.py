"""
ex13-5: duck typing to handle a string or an iterable of strings
"""


def check_field_names(field_names):
    """
    fileld_name: Union[str, Iterable[str]]
    """
    # note: fail fast and raise runtime errors soon
    try:  # assume it's a string
        field_names = field_names.replace(",", " ").split()
    except AttributeError:
        # not a string, and we assume it was already an iterable of names
        pass
    # to make sure it's an iterable and to keep our own copy
    # create a tuple out of what we have
    # a tuple is more compact than list, and it also
    # prevents my code from changing the names by mistake
    field_names = tuple(field_names)
    # use str.isidentifier to ensure every name is a valid
    if not all(s.isidentifier() for s in field_names):
        raise ValueError("field_names must all be valid identifiers")
    return


def main():
    field_names = "world"
    check_field_names(field_names)

    field_names = "world*hacker"
    check_field_names(field_names)


if __name__ == "__main__":
    main()
