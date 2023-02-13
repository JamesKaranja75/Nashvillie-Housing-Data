/* Cleaning Data in SQL Queries
*/
SELECT * FROM project.`nashville housing`;

#FILLING IN THE BLANK SPACES IN THE PROPERTYADDRESS COLUMN BY INSERTING THE NULL FUNCTION

SELECT propertyaddress FROM project.`nashville housing`;

set sql_safe_updates = 0;

update project.`nashville housing`
set propertyaddress = null
WHERE propertyaddress = ' ';

set sql_safe_updates = 1;

SELECT propertyaddress FROM project.`nashville housing` where propertyaddress is null;


#Subquery to populate the null rows in propertyaddress column

set sql_safe_updates = 0;

update project.`nashville housing` t1
join (select parcelID, propertyaddress FROM project.`nashville housing` where propertyaddress is not null) t2
on t1.parcelID = t2.parcelID
set t1.propertyaddress = t2.propertyaddress
where t1.propertyaddress is null;

SELECT propertyaddress FROM project.`nashville housing` where propertyaddress is null;


#Breaking out Address into individual columns (ADDRESS , CITY, STATE)

SELECT propertyaddress FROM project.`nashville housing`;
SELECT 
substring_index(propertyaddress,',' , 1),
substring_index(propertyaddress,',' , -1)
FROM project.`nashville housing`;

ALTER TABLE project.`nashville housing`
ADD PropertySplitAddress varchar (255);

set sql_safe_updates = 0;

UPDATE project.`nashville housing`
SET PropertySplitAddress = substring_index(propertyaddress,',' , 1);

ALTER TABLE project.`nashville housing`
ADD PropertySplitCity varchar (255);

set sql_safe_updates = 0;

UPDATE project.`nashville housing`
SET PropertySplitCity = substring_index(propertyaddress,',' , -1);

SELECT * FROM project.`nashville housing`;

SELECT OwnerAddress FROM project.`nashville housing`;

set sql_safe_updates = 0;

update project.`nashville housing`
set OwnerAddress = null
WHERE OwnerAddress = ' ';

SELECT * FROM project.`nashville housing`;

SELECT 
substring_index(OwnerAddress,',' , 1),
substring_index(substring_index(OwnerAddress,',' , -2), ',',1),
substring_index(OwnerAddress,',' , -1)
FROM project.`nashville housing`;

ALTER TABLE project.`nashville housing`
ADD OwnerSplitAddress varchar(255);

set sql_safe_updates = 0;

update project.`nashville housing`
SET OwnerSplitAddress = substring_index(OwnerAddress,',' , 1);

ALTER TABLE project.`nashville housing`
ADD OwnerSplitCity varchar(255);

set sql_safe_updates = 0;

update project.`nashville housing`
SET OwnerSplitCity = substring_index(substring_index(OwnerAddress,',' , -2), ',',1);

ALTER TABLE project.`nashville housing`
ADD OwnerSplitState varchar(255);

set sql_safe_updates = 0;

update project.`nashville housing`
SET OwnerSplitState = substring_index(OwnerAddress,',' , -1);

SELECT * FROM project.`nashville housing`;

#Change Y and N to Yes and No in "Sold as Vacant" Field

SELECT DISTINCT (SoldAsVacant) FROM project.`nashville housing`;

SELECT DISTINCT (SoldAsVacant), count(SoldAsVacant) FROM project.`nashville housing`
group by SoldAsVacant
order by 2;

SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'Y' then 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
 FROM project.`nashville housing`;
 
 set sql_safe_updates = 0;
 
 update project.`nashville housing`
 SET SoldAsVacant = CASE 
WHEN SoldAsVacant = 'Y' then 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END;

#Checking for Duplicates in MySQL

SELECT ParcelID,
                      PropertyAddress,
                      SalePrice,
                      SaleDate,
                      LegalReference,
                      count(*)
FROM project.`nashville housing`
group by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
having count(*) > 1;

#Delete Unused Columns

SELECT * FROM project.`nashville housing`;
ALTER TABLE project.`nashville housing`
DROP COLUMN PropertyAddress,
DROP COLUMN OwnerAddress;









