# class exercises in python
import sys

class Point:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y
    # __str__ returns a string representation of a  Point object
    # Printing an object implicitly invokes __str__ on the object,
    # so defining __str__ also changes the behavior of print
    def __str__(self):
        return '(' + str(self.x) + ', ' + str(self.y) + ')' 
    
    #operator overloading
    def __add__(self, other):
        return Point(self.x + other.x, self.y + other.y)

    #dot product, like  p1 * p2
    def __mul__(self, other):
        return self.x * other.x + self.y * other.y
    #scalar multiplication, like 2 * p1
    def __rmul__(self, other):
        return Point(other * self.x, other * self.y)

 #polymorphic -- a function that can operate on more than one type
#if all of the operations inside the function can be applied to the type,
#the function can be applied to the type
# we can use multadd(2,p1,p2), multadd(p1,p2,1)
def multadd (x, y, z):
    return x * y + z

#def PrintPoint(p):
#        print '(' + str(p.x) + ' , ' + str(p.y) + ')'


class Rectangle:
    pass

def FindCenter(box):
    p = Point()
    p.x = box.corner.x + box.width/2.0
    p.y = box.corner.y + box.height/2.0

    # import pdb; pdb.set_trace()
    
    return p

class Time:
    def __init__(self, hours=0, minutes=0, seconds=0):
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        
    def PrintTime(self):
        print str(self.hours) + ":" + str(self.minutes) + ":" + str(self.seconds)

    #  modifiers -- modify one or more of the objects it gets as arguments
    #            the caller keeps a reference to the objects it passes,
    #            so any changes the function makes are visible to the caller
    def Increment(self, seconds):
        self.seconds = self.seconds + seconds
        while self.seconds >= 60:
            self.seconds = self.seconds - 60
            self.minutes = self.minutes + 1
        
        while self.minutes >= 60:
            self.minutes = self.minutes - 60
            self.hours = self.hours + 1

    # pure function -- does not modify any of the objects passed to it as arguments
    #                  and it has no side effects, such as displaying a value or getting user input
    def AddTime(self, time2):
        sum = Time()
        sum.hours = self.hours + time2.hours
        sum.minutes = self.minutes + time2.minutes
        sum.seconds = self.seconds + time2.seconds

        if sum.seconds >= 60:
            sum.seconds = sum.seconds - 60
            sum.minutes = sum.minutes + 1
        
        if sum.minutes >= 60:
            sum.minutes = sum.minutes - 60
            sum.hours = sum.hours + 1
        
        return sum

def main():
    blank = Point(3.0, 4.0)

    box = Rectangle()
    box.width = 100.0
    box.height = 200.0
    box.corner = Point(0, 0)

    center = FindCenter(box)
    #PrintPoint(center)
    print center

    # functional programming style -- majority of functions are pure
    # write pure functions whenever it is reasonalbe to do so,
    # and resort to modifiers only if there is a compelling advantage
    # e.g. Time
    current_time = Time(9, 14, 30)
    bread_time = Time(3, 35)

    done_time = current_time.AddTime(bread_time)
    done_time.PrintTime()
    #done_time = AddTime(current_time, bread_time)
    #PrintTime(done_time)
    done_time.Increment(180)
    done_time.PrintTime()
    #defined_time = Increment(done_time, 180)
    #PrintTime(defined_time)
    
    # planned development
    # in this way, we get a program that is shorter, easier to read and debug, and more reliable
    # also easier to add features later
    # Algorithm is coming -- making a problem more general makes it easier

if __name__ == '__main__':
    main()
