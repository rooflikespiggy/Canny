# NUS Orbital Project 2021 - Canny

## Team Members:
Kang Yunru, Ruth

Emily Kok Fang Ning

## Project Documentation:
[Team Canny Documentation](https://docs.google.com/document/d/1h3EhTxIGTq1qZNmJ-EMcCXW4EAvF8Qw_jmZqraAEv-4/edit?usp=sharing)

## 1. Project Overview
### 1.1 Motivation
As university students who are venturing into adulthood, we find ourselves struggling to keep track of our finances. Some find it a hassle to note down every little purchase they make, while others simply don’t find the need to do so. However, it is definitely important for one to keep track of their finances as it is then would we know where your money goes and you can ensure that your money is used wisely.

Many have probably resulted in using money tracking applications on their phones, which are not user friendly, and are hard to use. When in a rush, one would not be in the right frame of mind to slowly navigate their way through the application, just to key in that they spent $3.50 on their chicken rice for lunch. And by the time the day ends, one would simply forget that they had spent that money on lunch. This might not seem to be a problem at the start, but as the amount snowballs, their spending habits are not accurately reflected through the application, thus the application is now purposeless to the user. At the end of the day, the user would simply delete the application.

### 1.2 Aim
We intend to create an **android application** to allow university students to have a proper budget planning as they venture into adulthood. This enables students to determine in advance whether they will have enough money to do the things they need to do or would like to do in the future.

### 1.3 User Stories
1. As a student who is entering adulthood, I want to have a targeted monthly spending.
2. As a student who has been worrying about my expenditure, I want to be able to keep track of my daily spendings. 
3. As a student, I tend to spend more on entertainment, I want to allow myself to keep track of my spendings in different categories such as entertainment, transport, food, etc.
4. As a student, I want to know if I still have sufficient budget to spend in that month.
5. As a student, I would like a simplified user interface to keep track of my spendings, but also a detailed report on my spending habits

### 1.4 Tech Stack
The following technologies will be used in the process of developing the mobile app:
* **Flutter & Dart:** for app development and front-end purposes
* **Firebase:** for back-end purposes
* **Git & GitHub:** for repository and source-code control

## 2. Features
### 2.1 Login Function
* **Login Page (email + password)**
  * Users will login using their registered email and password. If they do not have an account, link them to the register page. Login page will be linked to the Functions page.
* **Register Page**
  * Users will register an account with the app using their email and password if they are a first time user.
* **Functions Page**
  * Users can choose between inputting a quick input or viewing a comprehensive home screen. 
* **Quick Input**
  * Consists of just a number pad and buttons for the most used categories, which makes it easier for the user to just key in the amount and pick the category for the spending on the go.This segment will be linked to the receipt function.
* **Customisable Quick Input Screen**
  * Users can change the buttons to the most used categories to spendings the user makes on a frequent basis, to make keying in his expenditure even easier.

### 2.2 Dashboard Function
* **Category**
  * Shows the users expenditure categories. Users are able to key in any category where their expenditure falls under. In each category, there will be the total amount spent by the user for that category.
* **Statistics**
  * Keeping track of the percentage spent on each category. There will be a part showing the total amount spent so far by the user and the amount left for them to spend based on their monthly targeted spending amount. Once the total amount spent reaches 90% of the targeted spending amount, the users will be notified. 

### 2.3 Receipt Function
* **Spending**
  * Where users key in their spendings based on the category and date of spending. This segment will be linked to the categories and statistics fragment for calculation of statistics to determine the monthly spending by the user.

### 2.4 Insert Function
* **Add Targeted Expenditure**
  * For users to add their categories.
* **Add Category**
  * Users can choose between inputting a quick input or viewing a comprehensive home screen. 
* **Add Spending**
  * For users to add their spendings.

### 2.5 Reminder Function
* **Notification**
  * Reminds the user at a set time everyday to key in their expenses for the day. 

### 2.6 User Interactions
* **Forums**
  * For users to interact and share with their peers good tips to save money. Users can also share different deals they come across on the forums. This will also include a like system where users are able to like the posts and comments posted by other users.

