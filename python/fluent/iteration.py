"""
ch17 - Iterables, Iterators, and Generators
"""
import re

# producing object representations with limits on the size of the resulting strings
import reprlib

RE_WORD = re.compile(r"\w+")

# sentence_gen2.py
class Sentence:
    def __init__(self, text):
        self.text = text

    def __repr__(self):
        return f"Sentence({reprlib.repr(self.text)})"

    # iterator
    def __iter__(self):
        for match in RE_WORD.finditer(  # finditer builds an iterator over matches
            self.text
        ):
            yield match.group()  # yield MatchObject instance
        # return (match.group() for match in RE_WORD.finditer(self.text))


def test_sentence():
    s = Sentence('"The time has come," the walrus said,')
    for word in s:
        print(word)


if __name__ == "__main__":
    test_sentence()
