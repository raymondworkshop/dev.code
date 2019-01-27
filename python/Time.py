# -*- coding: utf-8 -*-
# @author: wenlong
# TODO


class Time:
    """ represents the time of day. """

    def __init__(self, hour=0, minute=0, second=0):
        self.hour = hour
        self.minute = minute
        self.second = second

    def __str__(self):
        # print '%.2d:%.2d:%.2d' % (self.hour, self.minute, self.second)
        return '%.2d:%.2d:%.2d' % (self.hour, self.minute, self.second)

    def int_to_time(self, seconds):
        minutes, self.second = divmod(seconds, 60)
        self.hour, self.minute = divmod(minutes, 60)

    def time_to_int(self):
        minutes = self.hour * 60 + self.minute
        seconds = minutes * 60 + self.second
        return seconds


def main():
    time = Time()
    # print(time)
    time.int_to_time(3100)
    print(time)


if __name__ == "__main__":
    main()
