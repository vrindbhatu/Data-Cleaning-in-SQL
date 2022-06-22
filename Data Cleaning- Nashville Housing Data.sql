/*
Cleaning Data in SQL Queries
*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

-- Updating SaleDate column
ALTER TABLE NashvilleHousing   -- Adding a new column SaleDateConverted to the table
ADD SaleDateConverted Date;

UPDATE NashvilleHousing        -- Adding value to the new column created while updating the SaleDate Column
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT SaleDateConverted       -- Displaying the new column
FROM NashvilleHousing

---------------------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address Date

SELECT PropertyAddress         -- Looking at the NULL values present in PropertyAddress column
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is NULL

SELECT *                       -- By looking here I observed that ParcelID is being repeated. So for the parcelID where in one data instance it has property address and one where it doesn't we can populate them.
FROM PortfolioProject.dbo.NashvilleHousing
--WHERE PropertyAddress is NULL
ORDER BY ParcelID

SELECT x.ParcelID,x.PropertyAddress,y.ParcelID,y.PropertyAddress, ISNULL(x.PropertyAddress,y.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing x
JOIN PortfolioProject.dbo.NashvilleHousing y
	on x.ParcelID = y.ParcelID                       -- Joining where the ParcelID is the same
	AND x.[UniqueID ] <> y.[UniqueID ]               -- But it should not be the same row
WHERE x.PropertyAddress is NULL

UPDATE x
SET PropertyAddress = ISNULL(x.PropertyAddress,y.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing x
JOIN PortfolioProject.dbo.NashvilleHousing y
	on x.ParcelID = y.ParcelID                      
	AND x.[UniqueID ] <> y.[UniqueID ]
WHERE x.PropertyAddress is NULL

--------------------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress                  
FROM PortfolioProject.dbo.NashvilleHousing

SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET  OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

UPDATE NashvilleHousing
SET  OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

UPDATE NashvilleHousing
SET  OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
 
SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N  to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant)

SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END

------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM PortfolioProject.dbo.NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddresS

