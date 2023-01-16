select * 

from Cleaning.dbo.NashvilleHousing


-------------------------------------------------------------------------------------

-- Standardize Date Format 

select SaleDateConverted,CONVERT(Date,SaleDate)
from Cleaning.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate=CONVERT(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted  Date ;

Update NashvilleHousing
set SaleDateConverted =CONVERT(Date,SaleDate)

------------------------------------------------------------------------------------

--Populate Property Address date 

select *
from Cleaning.dbo.NashvilleHousing

--where PropertyAddress is null 
order by ParcelID


----self Join on the same table 
----- replacing NULL

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,isnull(a.PropertyAddress,b.PropertyAddress)
from Cleaning.dbo.NashvilleHousing a
Join  Cleaning.dbo.NashvilleHousing b
 on a.ParcelID=b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]           /* Here i joined Only the PraceID And Not the UniqueID*/
 
 Where a.PropertyAddress is  null 

 update a
 set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
 from Cleaning.dbo.NashvilleHousing a
Join  Cleaning.dbo.NashvilleHousing b
 on a.ParcelID=b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]          
  Where a.PropertyAddress is null 


  ------------------------------------------------------------------------------------------------------------------------------




  --Breaking out Address into individual Columns ( Address,CityState)


  select PropertyAddress
from Cleaning.dbo.NashvilleHousing

--where PropertyAddress is null 
order by ParcelID

select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',' , PropertyAddress)-1) as Adress
,SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1 ,LEN(PropertyAddress)) as Adress
from Cleaning.dbo.NashvilleHousing



Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar (255);

Update NashvilleHousing
set PropertySplitAddress =SUBSTRING(PropertyAddress, 1,CHARINDEX(',' , PropertyAddress)-1)


Alter Table NashvilleHousing
Add PropertySplitCity nvarchar (255);

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1 ,LEN(PropertyAddress)) 


                                                                                                                           


---- another way of spitting 



select  OwnerAddress

from Cleaning.dbo.NashvilleHousing


 
 select 

Parsename(REPLACE(OwnerAddress,',' , '.'),3)
,parsename(REPLACE(OwnerAddress,',' , '.'),2)
,parsename(REPLACE(OwnerAddress,',' , '.'),1)

from Cleaning.dbo.NashvilleHousing



Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar (255);

Update NashvilleHousing
set OwnerSplitAddress =Parsename(REPLACE(OwnerAddress,',' , '.'),3)


Alter Table NashvilleHousing
Add OwnersPlitCity nvarchar (255);

Update NashvilleHousing
set OwnersPlitCity = parsename(REPLACE(OwnerAddress,',' , '.'),2)



Alter Table NashvilleHousing
Add OwnerSplitState nvarchar (255);

Update NashvilleHousing
set OwnerSplitState =parsename(REPLACE(OwnerAddress,',' , '.'),1)



-------------------------------------------------------------------------------------

--Change Y and N to yes and NO in  "Sold as Vacanr" field

select Distinct (SoldAsVacant) , COUNT(SoldAsVacant)
from Cleaning.dbo.NashvilleHousing

group by SoldAsVacant
order by 2



select SoldAsVacant
,case when SoldAsVacant='Y' then 'Yes'
  when SoldAsVacant ='N' then 'No'
  Else SoldAsVacant
  END
from Cleaning.dbo.NashvilleHousing

Update NashvilleHousing

Set SoldAsVacant =case when SoldAsVacant='Y' then 'Yes'
  when SoldAsVacant ='N' then 'No'
  Else SoldAsVacant
  END


  -----------------------------------------------------------------------------------
 
            --Remove Duplicates
			-- Partation the columns that are the same 

with RowNumCTE as (
Select*
,ROW_NUMBER() over (
partition by  
ParcelID,
PropertyAddress,
SalePrice,
LegalReference
ORDER BY 
UniqueID

   )Row_num

              
From Cleaning.dbo.NashvilleHousing 
--ORDER By ParcelID

)
Select*
from RowNumCTE
where Row_num >1                                 
--Order by PropertyAddress

select *

from Cleaning.dbo.NashvilleHousing



----------------------------------------------------------------------------------------------------------

---Delet Unused Columns


select *

from Cleaning.dbo.NashvilleHousing


Alter Table Cleaning.dbo.NashvilleHousing
Drop Column OwnerAddress ,TaxDistrict , PropertyAddress 

Alter Table Cleaning.dbo.NashvilleHousing
Drop Column SaleDate



------------------------------------------------------------------------------------------------