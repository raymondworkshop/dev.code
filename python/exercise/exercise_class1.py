"""
classes and inheritance
"""

__all__ = ['Subject', 'Student', 'Gradebook']

def class1():
    return

#
# note: create a layer of abstraction between interfaces and concrete implementations
#
# note: avoid doing more than one level of nesting (like dict contains dict, tuple) 
#  break it all out into classes - use multiple helper classes when internal state dict get complicated 
#
class SimpleGradebook(object): #stroe the student's name in a dict
    def __init__(self):
        self._grades = {}
    
    def add_student(self, name):
        self._grades[name] = []

    def report_grade(self, name, score):  #if weighted grades
        self._grades[name].append(score)

    def average_grade(self, name):
        grades = self._grades[name]
        return sum(grades) / len(grades)

# notes: updated - use multiple helper classes when internal state dict get complicated
class Subject(object): # a subject contains a set of grades
    def __init__(self):
        self._grades = []

    def report_grade(self, score, weight):
        self._grades.append((score, weight)) # tuple

    def weighted_grade(self):
        total, total_weight = 0, 0
        for score, weight in self._grades:
            total += score * weight
            total_weight += weight
        return total / total_weight

class Student(object):  # a student contains a set of subject
    def __init__(self):
        self._subjects = {}
    
    def subject(self, name):
        if name not in self._subjects:
            self._subjects[name] = Subject()
        return self._subjects[name]

    def average_grade(self):
        total, count = 0, 0
        for subject in self._subjects.values():
            total += subject.weighted_grade()
            count += 1

        return total / count

class Gradebook(object):
    def __init__(self):
        self._students = {}
    
    def student(self, name):
        if name not in self._students:
            self._students[name] = Student()  #class
        return self._students[name]


if __name__ == "__main__":
    class1()
