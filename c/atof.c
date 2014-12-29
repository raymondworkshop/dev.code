#include <ctype.h>
//The header declares several functions useful for testing and mapping characters
#include <stdio.h>

/* atof: convert string s to double */
double atof(char s[])
{
  double val, power, base, p;
  int i, sign, exp;

  /* skip white space */
  for(i = 0; isspace(s[i]); i++)
    ;

  /* for the sign */
  sign = (s[i] == '-') ? -1 : 1;
  if(s[i] == '+' || s[i] == '-')
    i++;

  /* for the integral number,123.123e-6*/
  for(val = 0.0; isdigit(s[i]); i++) //1)i++(postfix incrementing) is added after the test condition, ++i is added before the test
    val = 10.0 * val + (s[i] - '0');  // (1*10 + 2)*10 + 3

  /* for the decimal */
  if(s[i] == '.')
    i++;

  /* for the decimal part */
  for(power = 1.0; isdigit(s[i]); i++)
  {
    val = 10.0 * val + (s[i] - '0'); // (1*10 + 2)* 10 + 3
    power *= 10.0;           // [(1*10 + 2)* 10 + 3 ]/ 100     
  }

  /* for the exponent part */
  if(s[i] == 'e' || s[i] == 'E')
    i++;
  else
    return sign * val / power;

  base = (s[i] == '-') ? 0.1 : 10.0; //the key: 10^(-n) = (0.1)^n
  if(s[i] == '+' || s[i]== '-')
    i++;

  for(exp = 0; isdigit(s[i]); i++)
    exp = 10 * exp + (s[i] - '0');

  for(p = 1.0; exp > 0; --exp)
    p = p * base;  //(0.1)^exp

  return (sign * val/power) * p;
    
}

/*
main()
{
  printf("%f\n", atof("123.123e-6"));
  
}
*/
