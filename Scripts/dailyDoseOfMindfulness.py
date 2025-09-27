#Tashundre Gilmore
#Mindfulness program that provides tiny
#excersices each day to improve mental health

import random, time, sys, os

#typing effect for display
def typingPrint(text):
  for character in text:
    sys.stdout.write(character)
    sys.stdout.flush()
    time.sleep(0.05)
 
def typingInput(text):
  for character in text:
    sys.stdout.write(character)
    sys.stdout.flush()
    time.sleep(0.05)
  value = input()  
  return value

#Title and explanation 
def Intro():
    print()
    print("This program is designed to be a simple program that doesnt interfere")
    print("with one's daily life, thus the actitvites within only take a few minutes.")
    print("This is to help facilite mindfulness in order to help with mental health")
    time.sleep(7)
    print()
    print("Each day you will be provided a daily question or words of wisdom")
    print("along with a mini activity to do")
    
def tasks():
    typingPrint ("Start on a tasks that you keep putting off.")
    print("Stop making up exceuses to put it off. Just start on it")
    print("even if you dont finsh it today thats less work to do later")
    
    

#5 second breathing exercise
def breathe():
        
    typingPrint("Take A Moment To Just Breathe")
    time.sleep(2)
    print()
    typingPrint("Ready...")
    time.sleep(2)
    print()
    typingPrint("Set...")
    time.sleep(2)
    print()
    typingPrint("Breathe...")
    time.sleep(5)
    print()
    typingPrint("1.....")
    time.sleep(5)
    typingPrint("2.....")
    time.sleep(5)
    typingPrint("3.....")
    time.sleep(5)
    typingPrint("4.....")
    time.sleep(5)
    typingPrint("5.....")
    time.sleep(5)
    print()
    print("Feel Better?")

def walking():
    typingPrint("Go For A Walk")
    print()
    time.sleep(2)
    print("Go for a short walk (or long if you have the time) today")

def activity():
    typingPrint("Do an activity you enjoy that you havent done in a while")

def danceMusic():
    typingPrint("Listen To Music & Dance")

AOD=[tasks, breathe, walking, activity, danceMusic]

#think of a moment where you felt absolute joy

#take note of you feelings, reactions, and responses today


#words of wisdom
def wordsOfWisdom():
    
    global WOW

    typingPrint("----Daily Dose of Mindfulness----")
    time.sleep(2)

    print()
    
    #words of wisdom
    a=["Stop and take a moment to realize that this too shall pass."]
    b=["Its okay to feel whatever it is you are feeling right, whether its good or bad."]
    c=["You are good enough as you are now. You are worthy of love as you are now."]
    d=["The world's a horrible place sometime but that doesnt mean you have to be."]
    e=["Its okay to not be perfect. Embrace and acknowledge all parts of yourself."]

    #questions
    f=["Name a moment where you felt abandoned? Why? And by who?"]
    g=["What was your childhood like? And how does it affect you now?"]
    h=["What are some toxic traits that you have? And what are some ways you can overcome them?"]
    i=["What values and beliefs do you hold? And why?"]
    j=["What is something you have a hard time admitting to yourself? And why?"]

    WOW= a, b, c, d, e, f, g, h, i, j


def main():

    Intro()

    time.sleep(5)

    while True:

        print()
        wordsOfWisdom()
        wisdom=random.choice(random.choices(WOW, weights=map(len, WOW))[0])
        print(wisdom)

        time.sleep(4)

        print()

        random.choice(AOD)()

        time.sleep(2)

        print()

        #rerun program
        choice=input('\nRerun Program? (y/n): ')

        if choice == 'n':
            break

if __name__=="__main__":
    main()
