"""ex 23-9 

dynamic attribute programming
Computing attribute values using property
"""

import json

JSON_PATH = "/Users/zhaowenlong/workspace/proj/dev.programming/python/fluent/data/osconfeed.json"

# convert the JSON dataset to a dict storing instances of a Record class
#
class Record:  # return a dict with Record instances

    __index = None  # hold a reference to the dict returned by load

    def __init__(self, **kwargs):
        # create a bunch of attributes in the instance
        self.__dict__.update(
            kwargs
        )  # the __dict__ of an object is where its attributes are kept

    def __repr__(self):
        cls_name = self.__class__.__name__
        return f"<{cls_name} serial={self.serial!r}>"

    # staticmethod is like a plain function that happens to live in a class body
    # instead of being defined at the module level
    @staticmethod
    def fetch(key):
        if Record.__index is None:
            Record.__index = load()
        return Record.__index[key]


import inspect


def load(path=JSON_PATH):
    records = {}
    with open(path) as fp:
        raw_data = json.load(fp)
    for collection, raw_records in raw_data["Schedule"].items():
        record_type = collection[:-1]
        cls_name = record_type.capitalize()
        cls = globals().get(cls_name, Record)
        if inspect.isclass(cls) and issubclass(cls, Record):
            factory = cls
        else:
            factory = Record
        for raw_record in raw_records:
            key = f'{record_type}.{raw_record["serial"]}'
            records[key] = factory(**raw_record)
    return records


class Event(Record):
    def __repr__(self):
        if hasattr(self, "name"):
            cls_name = self.__class__.__name__
            return f"<{cls_name} {self.name!r}>"
        else:
            return super().__repr__()

    @property  # the venue property in event class
    def venue(self):
        key = f"venue.{self.venue_serial}"
        return self.__class__.fetch(key)


def main():
    event = Event.fetch("event.33457")
    print(event.venue_serial)
    return


if __name__ == "__main__":
    main()
