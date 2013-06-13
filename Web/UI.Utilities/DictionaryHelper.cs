using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using System.Web.Script.Serialization;
using System.Xml.Linq;

namespace Elcondor.UI.Utilities {
    public static class DictionaryHelper {
        public static List<TblCity> GetCityListData (int districtId) {
            List<TblCity> list = new List<TblCity>();
            var jss = new JavaScriptSerializer();
            var dict = jss.Deserialize<dynamic>(BizDictionary.GetCityListByDistrictJS(districtId));
            foreach (var itm in dict) {
                TblCity tbl = new TblCity();
                tbl.Id = itm["Id"];
                tbl.Name = itm["Name"];
                tbl.CountryId = itm["CountryId"];
                tbl.RegionId = itm["RegionId"];
                tbl.Description = itm["Description"];
                tbl.Latitude = itm["Latitude"];
                tbl.Longitude = itm["Longitude"];
                tbl.IsCapital = itm["IsCapital"];
                list.Add(tbl);
            }
            var q = from p in list
                    orderby p.IsCapital
                    select p;
            return q.ToList();
        }

        public static List<TblRegion> GetDistrictListData (int countryId) {
            List<TblRegion> list = new List<TblRegion>();
            var jss = new JavaScriptSerializer();
            var dict = jss.Deserialize<dynamic>(BizDictionary.GetDistrictListJS(countryId));
            foreach (var itm in dict) {
                TblRegion tbl = new TblRegion();
                tbl.Id = itm["Id"];
                tbl.Description = itm["Description"];
                tbl.Name = itm["Name"];
                list.Add(tbl);
            }
            return list;
        }

        public static List<TblRegion> GetDistrictListWithArticlesByCountryId (int countryId) {
            List<TblRegion> list = new List<TblRegion>();
            var jss = new JavaScriptSerializer();
            var dict = jss.Deserialize<dynamic>(BizDictionary.GetDistrictListWithArticlesByCountryIdJS(countryId));
            foreach (var itm in dict) {
                TblRegion tbl = new TblRegion();
                tbl.Id = itm["Id"];
                tbl.Description = itm["Description"];
                tbl.Name = itm["Name"];
                list.Add(tbl);
            }
            return list;
        }

        public static List<TblCountry> GetCountryListData () {
            return GetCountryListData(false);
        }

        public static List<TblCountry> GetCountryListData (bool hasSelectAllRow) {
            List<TblCountry> list = new List<TblCountry>();
            var jss = new JavaScriptSerializer();
            var dict = jss.Deserialize<dynamic>(BizDictionary.GetCountryListJS());
            TblCountry allRow = new TblCountry();
            allRow.Name = "Все";
            allRow.Id = -1;
            if (hasSelectAllRow)
                list.Add(allRow);
            foreach (var itm in dict) {
                TblCountry tbl = new TblCountry();
                tbl.Id = itm["Id"];
                tbl.Name = itm["Name"];
                tbl.Description = itm["Description"];
                list.Add(tbl);
            }
            return list;
        }

        public static List<TblSightseeingType> GetSightseeingTypeListData () {
            List<TblSightseeingType> list = new List<TblSightseeingType>();
            var jss = new JavaScriptSerializer();
            var dict = jss.Deserialize<dynamic>(BizDictionary.GetSightseeingTypeListJS());
            foreach (var itm in dict) {
                TblSightseeingType tbl = new TblSightseeingType();
                tbl.Id = itm["Id"];
                tbl.Description = itm["Description"];
                list.Add(tbl);
            }
            return list;
        }
    }
}