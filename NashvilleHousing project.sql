--cleaning data in SQL Query

select *
from PortfolioProject.dbo.NashvilleHousing


--standardised data format

select SaleDateConverted, convert(date, saleDate)
from PortfolioProject.dbo.NashvilleHousing


update NashvilleHousing
set SaleDate = CONVERT(date, SaleDate)

Alter table NashvilleHousing
Add SaleDateConverted Date;


update NashvilleHousing
set SaleDateConverted = CONVERT(date, SaleDate)

--Populate Property Address Date
select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is Null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



--bring out address into individual column (Address, city, state)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is Null
--order by ParcelID

select
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address,
substring (PropertyAddress, charindex(',', PropertyAddress) +1, len(propertyAddress)) as Address

from PortfolioProject.dbo.NashvilleHousing


Alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1)


Alter table NashvilleHousing
Add PropertySplitCity Nvarchar(255);


update NashvilleHousing
set PropertySplitCity = substring (PropertyAddress, charindex(',', PropertyAddress) +1, len(propertyAddress)) 


select *
from PortfolioProject.dbo.NashvilleHousing




select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select 
PARSENAME(replace(OwnerAddress, ',', '.'), 3),
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from PortfolioProject.dbo.NashvilleHousing



Alter table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.'), 3)


Alter table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2) 


Alter table NashvilleHousing
Add OwnerSplitState Nvarchar(255);


update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'), 1) 



select *
from PortfolioProject.dbo.NashvilleHousing


--change Y and N to Yes and No in "sold as vacant" field

select distinct(soldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by SoldAsVacant


select SoldAsVacant,
CASE when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'NO'
	 else SoldAsVacant
	 END
from PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'NO'
	 else SoldAsVacant
	 END


	 --Remove duplicates

	 With Row_NumCTE as (
	 select *,
	 ROW_NUMBER() over (
	 Partition by ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				  UniqueID
				  ) Row_num
	from PortfolioProject.dbo.NashvilleHousing
	)
	select*
	 from Row_NumCTE
	 where Row_num > 1
	 order by PropertyAddress


select *
from PortfolioProject.dbo.NashvilleHousing




--Delete unused Columns


select *
from PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing
drop column PropertyAddress, OwnerAddress, TaxDistrict, SaleDate





























