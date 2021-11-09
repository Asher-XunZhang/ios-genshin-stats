# Genshin Impact Stater

|Name|NetID|
|:---:|:---:|
|Kamiku Xue|yxue|
|Xun Zhang|xzhang|

## Intro
In this project, we are going to desian and helper application to get the statsatic of characters data for the **Genshin Impact Game**. Also, the user can modify the current data and add new customer characters.

## Model
We have the basic NSManagerObject to save the data to the core data
Here is the fields

|Name|Type|Des|
|:----:|:----:|:----:|
|name|String|The character name|
|avatar|Binary Data|The image of character avatar|
|level|Float|The character level|
|mainRole|String|The main role/position of character|
|element|String|The character element|
|ascension|String|The character ascension|
|rarity|Integer32|The character rarity(4, 5, sp)|
|weapon|String|The weapon of character|
|baseATK|Integer32|The base attack value of character|
|baseHP|Integer32|The base HP value of character|
|baseDEF|Integer32|The base defense value of character|
|rating|Double|The rating of character|
|comment|String|The comment of character|

## Feature
- Load the csv file *Built in* of character data.
- Edit the character table
- Deteil info of character
- Delete in the detail page
- Upload and save image of character
- Core data storage of all data
- Dynmic data render according to the selected level

## References
- [Star Rating Plugin - Cosmos](https://github.com/evgenyneu/Cosmos#:~:text=This%20is%20a%20UI%20control,those%20inescapable%201%2Dstar%20reviews!)



