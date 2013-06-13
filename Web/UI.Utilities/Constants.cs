using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Elcondor.UI.Utilities {
    public static class Constants {
        public const int JSONPositiveResult = 1;
        public const int JSONNegativeResult = 0;

        public const int NoValueSelected = -1;
        public const int NullValueSelected = 0;

        public const int ImgMaxFlagHeight = 80;
        public const int ImgMaxAlbumImageHeight = 500;

        public const string JSONNullElementValue = "null";
                
        public const int PageIndexId = 1;
        public const int PageIndividualToursId = 2;
        public const int PageForClientId = 3;
        public const int PageBankAccountId = 4;
        public const int PagePaymentMethodId = 5;
        public const int PageContactsId = 6;

        public const int ColSightseeingListId = 1;
        public const int ColSightseeingListType = 2;
        public const int ColSightseeingListName = 3;
        public const int ColSightseeingListCountryRegion = 4;
        public const int ColSightseeingListDateCreated = 5;

        public const int ColTourListId = 1;
        public const int ColTourListName = 2;
        public const int ColTourListCountry = 3;        
        
        //Admin constants:
        public const string DictionaryItemSightseeing = "sightseeing";
        public const string DictionaryItemCountry = "country";
        public const string DictionaryItemCountryInfo = "countryinfo";
        public const string DictionaryItemDistrict = "district";
        public const string DictionaryItemCity = "city";
        public const string DictionaryItemTour = "tour";
        public const string DictionaryItemRegionRecreation = "regionrecreationtype";
        public const string DictionaryItemExcurs = "excurs";
        public const string DictionaryItemCruise = "cruise";
        public const string DictionaryItemTag = "tag";

        public const string DictionaryPageDistrictList = "/Admin/RegionListEdit";
        public const string DictionaryPageCountryList = "/Admin/CountryListEdit";
        public const string DictionaryPageCountryInfoList = "/Admin/CountryEdit";
        public const string DictionaryPageCityList = "/Admin/CityListEdit";
        
        public const string DictionaryPageSightseeingTypeList = "/Admin/SightseeingTypeList";
    }
}