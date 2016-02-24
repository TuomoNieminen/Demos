
### Use your head()

<br>
  

```r
head(x=data, n=3)
```

```
##      X      Y  Z G
## 1 6.01   high  9 1
## 2 5.79 medium  9 1
## 3 7.83 medium 10 1
```

Here we called the function `head()`, which wants us to give it inside the parenthesis two specific things: `x` and `n`. these are the arguments of the function. Once we told `head()` that `x=data` and `n=3`, it knew that we wanted the first three rows of mydata.

In R you can also save any function output by using the assign operator `<-`. Below we define our own new object data_top3 by saving the output of `head()` to it.


```r
data_top3 <- head(data, 3)
```

Notice that when we gave `head()` the information about `x` and `n` in the right order, we didn't have to explicitly state which is which.  

Now that we have our object saved, we can acces that object later and for example print it by typing it's name.


```r
data_top3
```

```
##      X      Y  Z G
## 1 6.01   high  9 1
## 2 5.79 medium  9 1
## 3 7.83 medium 10 1
```

  
### Exercise 1

<br>

Let's try it! Use `head()` to display the first 10 rows of mydata. Then save this output to a new object called `ans`.  

Once you have received a green feedback, proceed to the next demo, where you will take a closer look at your variables!



