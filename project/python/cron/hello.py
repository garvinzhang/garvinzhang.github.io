from datetime import datetime
from schedule import every, repeat, run_pending

# pip install schedule


@repeat(every(3).seconds)
def task():
    now = datetime.now()
    ts = now.strftime("%Y-%m-%d %H:%M:%S")
    print(ts + "-333!")


@repeat(every(5).seconds)
def task2():
    now = datetime.now()
    ts = now.strftime("%Y-%m-%d %H:%M:%S")
    print(ts + "-555555!")


@repeat(every().days.at("10:00:00"))
def task3():
    print("hello")


while True:
    run_pending()
