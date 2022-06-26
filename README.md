# Data-Cleaning-in-SQL


I have performed Data Cleaning on Nashville dataset by using structured query language.

Query 1: For the first query I have added a new column SaleDateConverted in which I updated the SaleDate column by removing the timestamp formart and only keeping
MM/DD/YYYY format
Ouput for the resulted query:

<img width="497" alt="ResultOfQuery1" src="https://user-images.githubusercontent.com/70003172/175785176-8de3d68c-08e6-4083-a32d-ebdf44fbd89c.png">



Query 2: For the second query I have populated the missing data in the property address column. After observing the data I observed that the each address had a unique parcelID. And there were repeated fileds of address. So I have performed self join on the table on columns parcelID and UniqueID and filled the missing property address.

Ouput for the resulted query:

<img width="758" alt="ResultOfQuery2" src="https://user-images.githubusercontent.com/70003172/175834455-61225bb4-8749-4c67-8f81-b7a6e47251e7.png">

As you can see in the above image that all the missing values for the column propertyAddress is being filled.



Query 3:  For the third query I have splitted propertyAddress and OwnerAddress into address, city and state colume.

Ouput for the resulted query:

<img width="507" alt="ResultOfQuery3" src="https://user-images.githubusercontent.com/70003172/175834890-10d9b82e-8ba0-4e98-8186-006184d49606.png">



Query 4:  For the forth query I have cleaned the "Sold as Vacant" column. It had four values: "N", "Y", "No", "Yes". I have converted all the N's to No and all the Y's to Yes to make the values consistent.

Ouput for the resulted query:











