
# What 
This code shows how the C++ STL container methods push_back and
emplace_back are different.

# How
Build the code using `g++ --std=c++11 <source file>`. Each source file
is its own executable. The output they produce pretty self-explanatory.

# How these two methods differ
TL;DR
When emplace_back is used and objects are created using the emplace_back()
method it does not copy objects while building the vector and when combined
with a call to reserve to pre-allocate memory for the vector is the best
performance of the six programs.

## The push_back method does not understand move semantics

### Look at the push_back method
A simple use of the push_back method on an object with its own constructor,
copy constructor and destructor makes lots of objects. To build a vector of three
objects, the copy ctor and dtor are each called 6 times!

	vertices.push_back(GFG(1));
	cout << endl;

	vertices.push_back(GFG(11));
	cout << endl;

	vertices.push_back(GFG(21));
	cout << endl;

Output:
    length of vertices:0
    
    Constructor=>x:1
    Copied=>x:1
    destructor=>x:1
    
    Constructor=>x:11
    Copied=>x:11
    Copied=>x:1
    destructor=>x:1
    destructor=>x:11
    
    Constructor=>x:21
    Copied=>x:21
    Copied=>x:11
    Copied=>x:1
    destructor=>x:11
    destructor=>x:1
    destructor=>x:21
    
    destructor=>x:21
    destructor=>x:11
    destructor=>x:1

### Look at push_back when we build objects 'directly'
This will save a superfluous call to the object's constructor,
or it should, but without move semantics this is just as bad as before.

    vertices.push_back(1);
    cout << endl;

	vertices.push_back(11);
	cout << endl;

	vertices.push_back(21);
	cout << endl;

Output:
    length of vertices:0
    
    Constructor=>x:1
    Copied=>x:1
    destructor=>x:1
    
    Constructor=>x:11
    Copied=>x:11
    Copied=>x:1
    destructor=>x:1
    destructor=>x:11
    
    Constructor=>x:21
    Copied=>x:21
    Copied=>x:11
    Copied=>x:1
    destructor=>x:11
    destructor=>x:1
    destructor=>x:21
    
    destructor=>x:21
    destructor=>x:11
    destructor=>x:1

### What if we reserve space in the vector for the objects?
This is better, much better, but we'll see that emplace_back can 
improve on this.

    vertices.reserve(3);
        
	cout << endl;
	// Custom input entries
	vertices.push_back(1);
	cout << endl;

	vertices.push_back(11);
	cout << endl;

	vertices.push_back(21);
	cout << endl;

Output:

    length of vertices:0
    
    Constructor=>x:1
    Copied=>x:1
    destructor=>x:1
    
    Constructor=>x:11
    Copied=>x:11
    destructor=>x:11
    
    Constructor=>x:21
    Copied=>x:21
    destructor=>x:21
    
    destructor=>x:21
    destructor=>x:11
    destructor=>x:1

## The emplace_back method does support move semantics 

### Simple call to emplace back with a zero-length vector
Check out the output. Sadly, it's not any better than push_back

	vertices.emplace_back(GFG(1));
	cout << endl;

	vertices.emplace_back(GFG(11));
	cout << endl;

	vertices.emplace_back(GFG(21));
	cout << endl;

Output:

    length of vertices:0
    
    Constructor=>x:1
    Copied=>x:1
    destructor=>x:1
    
    Constructor=>x:11
    Copied=>x:11
    Copied=>x:1
    destructor=>x:1
    destructor=>x:11
    
    Constructor=>x:21
    Copied=>x:21
    Copied=>x:11
    Copied=>x:1
    destructor=>x:11
    destructor=>x:1
    destructor=>x:21
    
    destructor=>x:21
    destructor=>x:11
    destructor=>x:1

### What if we use reserve on the vector?
With reserve, we get a reduction in the number of calls, but can we do better?

    vertices.reserve(3);

	vertices.emplace_back(GFG(1));
	cout << endl;

	vertices.emplace_back(GFG(11));
	cout << endl;

	vertices.emplace_back(GFG(21));
	cout << endl;

Output:

    length of vertices:0
    
    Constructor=>x:1
    Copied=>x:1
    destructor=>x:1
    
    Constructor=>x:11
    Copied=>x:11
    destructor=>x:11
    
    Constructor=>x:21
    Copied=>x:21
    destructor=>x:21
    
    destructor=>x:21
    destructor=>x:11
    destructor=>x:1

## Keep the reserve call and use an alternate way of building objects
This is the best yet - the code does not call the object's copy 
constructor; only the constructor and destructor are called _and_ they
are called the minimal number of times.

    vertices.reserve(3);
        
	cout << "length of vertices:" << vertices.size() << endl;

	// Inserting elements in the object
	// created using emplace_back() method
	cout << endl;
	// Custom input entries
	vertices.emplace_back(1);
	cout << endl;

	vertices.emplace_back(11);
	cout << endl;

	vertices.emplace_back(22);
	cout << endl;

Output:
    length of vertices:0
    
    Constructor=>x:1
    
    Constructor=>x:11
    
    Constructor=>x:22
    
    destructor=>x:22
    destructor=>x:11
    destructor=>x:1
