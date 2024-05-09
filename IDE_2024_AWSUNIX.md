---
layout: tutorial_page
permalink: /IDE_2024_AWSUNIX
title: AWS/Unix Review for IDE 2024
header1: Workshop Pages for Students
header2: AWS and Unix intro
image: /site_images/CBW_epidemiology_icon.png
home: https://bioinformaticsdotca.github.io/IDE_2024
---

-----------------------

# Connecting and properly using a cloud computing cluster at the CBW

*by Jose Hector Galvez, Zhibin Lu & Rob Syme*

---

## Schedule:

Today's schedule can be found [here](https://bioinformaticsdotca.github.io/AWS_IDE24_Schedule).

## Contents:

1. [Logging into AWS ](#aws_login)

2. [Introduction to the command line](#command_line_intro)

    2.1 [Exercise: Exploring the filesystem](#filesystem_exploration)

3. [File manipulation](#file_manip)

    3.1 [Exercise: Reading text files](#read_files)

    3.3 [Exercise: Editing text files](#edit_file)

4. [Searching and sorting files](#search_sort)

5. [Putting it all together](#conclusion)

-----------------------

<a name="aws_login"></a>
## 1. Logging into AWS

#### Description of the lab:
This section will show students how to login to AWS.

[Slides (pdf)](https://drive.google.com/file/d/1L-MA6JKrPQTkOdRsLNXlsa2Gu7Iq3JaC/view?usp=sharing)

You can find the instructions [here](https://bioinformaticsdotca.github.io/AWS_setup).

-----------------------
<a name="command_line_intro"></a>
## 2. Introduction to the command line

### Description of the lab:
This section will show students the basics of the command line, with a focus on navigation.

- [Slides (pdf)](https://drive.google.com/file/d/1i4e4DuBNHn3NK2eiV1XSmTTppSuF967c/view?usp=share_link)

<a name="filesystem_exploration"></a>
### Exercise: Exploring the filesystem

1. Connect to your AWS instance

2. Type the `pwd` command - what is the output?
<details>
  <summary>
Solution
  </summary><p>


```bash
$ ls
CourseData  R  workspace
```


The `ls` command lists the contents of a working directory.

</p></details>



3. Type the `ls` command - what is the output?

<details>
  <summary>
Solution
  </summary>


```bash
$ pwd
/home/ubuntu
```

The `pwd` command shows the absolute *path to the working directorpwy*.

</details>


-----------------------
<a name="file_manip"></a>
## 3. File manipulation

### Description of the lab:
This section will show students how to manipulate files, including reading, editing, and renaming text files.

- [Slides (pdf)](https://drive.google.com/file/d/1ohY4xskAeyqwsGB-Z5BUBJemCz91j1Tq/view?usp=sharing)


### Additional material:
Here are two cheat-sheets that can be useful to have as a reference for common UNIX/Linux commands:

- [FOSSwire.com Unix/Linux Command Reference](https://files.fosswire.com/2007/08/fwunixref.pdf)
- [SUSO.org Unix/Linux Command Syntax and Reference](https://i.redd.it/6s2q64ticje51.png)

<a name="read_files"></a>
### Exercise: Reading text files

Using the commands you just learned, explore the file in the ~/CourseData/IDE_data/UnixFiles directory. 

1. Is the file a text file?

<details>
  <summary>
Solution
  </summary>

Yes. You can use `less`, `cat`, `head`, or `tail` and get human-readable info. Note that this doesn't have anything to do with its file extension.
</details>


2. How many lines does the file have?

<details>
  <summary>
Solution
  </summary>


```bash
$ wc -l GCF_009858895.2_ASM985889v3_genomic.gff 
67 GCF_009858895.2_ASM985889v3_genomic.gff
```

There are 67 lines in this file.

</details>

  

3. Can you read the content of the file using less?

<details>
  <summary>
Solution
  </summary>

```bash
$ less GCF_009858895.2_ASM985889v3_genomic.gff 
```

</details>

---
<a name="edit_files"></a>
### Exercise: Editing text files

Using the commands you just learned, create a file called helloworld.txt and edit it using nano. 

1. Write “Hello world” into the file. Save the file and exit nano. 
2. Create a subdirectory called “test”; move the helloworld.txt file into test.
3. Create a copy of the helloworld.txt file called helloworld2.txt 

1. First, use the `nano` command to open a file called `helloworld.txt`
<details>
  <summary>
Solution
  </summary>

```bash
$ nano helloworld.txt
```

Inside the nano editor, write "Hello world", then use the `^O` option to write the changes and `^X` to exit.

</details>




2. Create a subdirectory called “test”; move the helloworld.txt file into test.
<details>
  <summary>
Solution
  </summary>


First, use the command `mkdir` to create this new directory. Then, use `mv` to move `helloworld.txt` into this directory.


```bash
$ mkdir test
$ mv helloworld.txt test/
```

</details>


3. Create a copy of the `helloworld.txt` file called `helloworld2.txt`. 

<details>
  <summary>
Solution
  </summary>

First, change the working directory using `cd`, then use the `cp` command to create the copy.

```bash
$ cd test
$ cp helloworld.txt helloworld2.txt

```

</details>


-----------------------
<a name="search_sort"></a>
## 4. Searching and sorting files

### Description of the lab:
This section will show students how to search for and in files.

Workshop notes and quiz questions [here](/AWS_IDE23_module4).

-----------------------
<a name="conclusion"></a>
## 5. Putting it all together

### Description of the lab:
This section will show students how the basic concepts fit together and how they apply in the context of bioinformatics.

Workshop notes and quiz questions [here](/AWS_IDE23_module5).


