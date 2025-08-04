import unittest

#compare function
def compareValues(X, Y):
    try:
        X = int(X)
        Y = int(Y)
        #Greater than
        if X > Y:
            return str(X) + " > " + str(Y)
        #less than
        elif X < Y:
            return str(X) + " < " + str(Y)
        #Equal to
        elif X == Y:
            return str(X) + " = " + str(Y)

        
    except ValueError:
        raise ValueError("Invalid Input. Both X and Y must be integers.")
        X = input("Enter a value for X: ")
        Y = input("Enter a value for Y: ")

           
def get_integer_input(prompt):
    while True:
        try:
            value = int(input(prompt))
            return value
        except ValueError:
            print("Invalid Input. Must be an integer.")

def run_comparison():
    input_X = get_integer_input("Enter a value for X: ")
    input_Y = get_integer_input("Enter a value for Y: ")

    result = compareValues(input_X, input_Y)
    print(result)

class TestCompareValues(unittest.TestCase):
    def test_TC1(self):
        expected_output = compareValues("10","10")
        self.assertEqual(expected_output,"10 = 10")

    def test_TC2(self):
        expected_output = compareValues("-5","15")
        self.assertEqual(expected_output,"-5 < 15")

    def test_TC3(self):
      expected_output = compareValues("20","-1")
      self.assertEqual(expected_output,"20 > -1")

    def test_invalid_input(self):
        with self.assertRaises(ValueError) as context:
            compareValues("five", "5")
        self.assertEqual(str(context.exception), "Invalid Input. Both X and Y must be integers.")

    
if __name__ == '__main__':
    run_comparison()
    unittest.main()
