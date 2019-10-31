import os
import unittest


from exercise_class import SimpleGradebook
from exercise_class import Gradebook

class TestSimpleGradebook(unittest.TestCase):
    #student = 'Isaac Newton'
    book = SimpleGradebook()
    book.add_student('Isaac Newton')
    book.report_grade('Isaac Newton', 90)
    print(book.average_grade('Isaac Newton'))


class TestGradebook(unittest.TestCase):
    book = Gradebook()
    albert = book.student('Albert Einstein')
    math = albert.subject('math')
    math.report_grade(80, 0.10)
    math.report_grade(92, 0.30)
    #eng = albert.subject('eng')
    #eng.report_grade(92, 0.15)
    #
    print(albert.average_grade())

if __name__ == '__main__':
    unittest.main()
