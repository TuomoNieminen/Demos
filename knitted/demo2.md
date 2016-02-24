
### Know your variables

<br>

Next we take a look at the following functions and learn how to draw a barplot. 


- `str()` shows information about an object, most importantly it's type
- `table()` shows the counts of each category of a factor
- `barplot()` draws a barplot from named counts

Let's first create some simple data for demostration purposes. We'll use `c()` to combine values into a vector.


```r
myVector <- c(1,2,3,4,5,6,7,8,9,10,11,12,13)
myVector
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13
```

Next we use `cut()` to assign each element of myVector to an interval, creating a factor. We can use `c()` inside `cut()` and define the cutpoints with the argument `breaks`.


```r
myFactor <- cut(myVector, breaks=c(0,5,10,15))
myFactor
```

```
##  [1] (0,5]   (0,5]   (0,5]   (0,5]   (0,5]   (5,10]  (5,10]  (5,10] 
##  [9] (5,10]  (5,10]  (10,15] (10,15] (10,15]
## Levels: (0,5] (5,10] (10,15]
```

The numbers inside the brackets at the beginning of the rows are R's way of telling us which element of `myFactor` starts the row. R also let's us know the levels of the factor, nice!

But what if we already have some factors in our data - earlier it looked like mydata might have contained a factor. If objects have types, how can we tell that type?

We can use `str()` to check the type of any object. If that object contains other objects, those types are shown as well. We'll combine myvector and myFactor into a data frame and check if the types of are indeed what we think they are.


```r
myDataframe <- data.frame(myvec=myVector, myfac=myFactor)
str(myDataframe)
```

```
## 'data.frame':	13 obs. of  2 variables:
##  $ myvec: num  1 2 3 4 5 6 7 8 9 10 ...
##  $ myfac: Factor w/ 3 levels "(0,5]","(5,10]",..: 1 1 1 1 1 2 2 2 2 2 ...
```

So we have a numeric vector with 13 values and a factor with 3 levels, great!  

Now that we have a factor, we can for example create a table to see how many values are in each category.


```r
table(myFactor)
```

```
## myFactor
##   (0,5]  (5,10] (10,15] 
##       5       5       3
```

As before, we can assign the output of `table()` to an object. We can then visualise the counts with `barplot()`. Let's choose a green color for the bars and give the plot a main title.


```r
myTable <- table(myFactor)
barplot(myTable, col="green", main="my barplot")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)

### Exercise 2

Now let's get you back to your own data!  

1. Use `str()` to find out which variable in mydata is categorical
2. Create a table of that variable
3. Store your table for further use
4. Draw a barplot of your categorical variable

<br>


