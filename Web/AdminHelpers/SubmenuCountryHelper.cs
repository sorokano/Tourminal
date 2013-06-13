using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.AdminHelpers {
    public static class SubmenuCountryHelper {
        public static string GetMenu () {
            StringBuilder sb = new StringBuilder();
            List<LinqToElcondor.TblSightseeingType> list = new List<LinqToElcondor.TblSightseeingType>();
                                                   var jss = new System.Web.Script.Serialization.JavaScriptSerializer();
                                                   var dict = jss.Deserialize<dynamic>(ElcondorBiz.BizDictionary.GetSightseeingTypeListJS());
                                                   LinqToElcondor.TblSightseeingType allRow = new LinqToElcondor.TblSightseeingType();
                                                   StringBuilder sights = new StringBuilder();
                                                   foreach (var itm in dict)
                                                       sights.Append(string.Format("<li><a href=\"../../Admin/AddSightseeing?typeid={0}&regionid={1}&countryid={2}\">{3}</a></li>"
                                                                                                    , itm["Id"], "{0}", "{1}", itm["Description"]));
            sb.Append("<ul>");
            foreach (TblCountry cntr in DictionaryHelper.GetCountryListData(false)) {
                sb.Append(string.Format("<li><a href=\"../../Admin/CountryEdit?id={0}\" id=\"cntr{0}\">{1} <span class=\"dc-icon\"></span></a>", cntr.Id, cntr.Name));
                sb.Append("<ul>");
                sb.Append(string.Format(" <li><a href=\"../../Admin/CountryEdit?id={0}\" id=\"cntryed{0}\">Редактировать страну</a></li>", cntr.Id));

                sb.Append(" <li><a href=\"#\" id=\"addacticle\">Добавить статью <span class=\"dc-icon\"></span></a>");
                sb.Append("     <ul>");
                sb.Append(string.Format(sights.ToString(), Constants.NoValueSelected, cntr.Id));
                sb.Append("     </ul>");
                sb.Append("</li>");

                sb.Append("<li style=\"background-color:#fff;\">Регионы:</li>");
                TblCity capital = BizCity.GetCapitalCity(cntr.Id);
                if (capital != null) {
                    TblRegion capregn = BizRegion.GetRegionById(capital.RegionId);
                    sb.Append(string.Format("<li><a href=\"../../Admin/CityEdit?id={0}\" id=\"capregn{0}\">Столица: {1}</a></li>", capital.Id, capital.Name));
                }
                foreach (TblRegion regn in DictionaryHelper.GetDistrictListData(cntr.Id)) {
                    if (capital == null || regn.Id != capital.RegionId) {
                        sb.Append(string.Format("<li><a href=\"../../Admin/RegionEdit?id={0}\" id=\"regn{0}\">{1} ({2}) <span class=\"dc-icon\"></span></a>", regn.Id, regn.Name, BizRegion.GetRegionCityCount(regn.Id)));
                        sb.Append("<ul>");
                        sb.Append(string.Format(" <li><a href=\"../../Admin/RegionEdit?id={0}\" id=\"regned{0}\">Редактировать регион</a></li>", regn.Id));
                        sb.Append(string.Format(" <li><a href=\"../../Admin/AddTour?regionid={0}&countryid={1}\" id=\"regntour{0}\">Добавить тур</a></li>", regn.Id, cntr.Id));
                        sb.Append(string.Format(" <li><a href=\"../../Admin/AddExcurs?regionid={0}&countryid={1}\" id=\"regnexc{0}\">Добавить экскурсию</a></li>", regn.Id, cntr.Id));
                        sb.Append(string.Format(" <li><a href=\"../../Admin/AddCruise?regionid={0}&countryid={1}\" id=\"regncruise{0}\">Добавить круиз</a></li>", regn.Id, cntr.Id));
                        sb.Append(" <li><a href=\"#\" id=\"addacticle\">Добавить статью <span class=\"dc-icon\"></span></a>");
                        sb.Append("     <ul>");
                        sb.Append(string.Format(sights.ToString(), regn.Id, cntr.Id));
                        sb.Append("     </ul>");
                        sb.Append("</li>");
                        sb.Append("</ul>");
                    }
                }
                sb.Append("</ul>");
            }
            sb.Append("</ul>");
            return sb.ToString();
        }




            //ViewData["SightseeingTypeList"] = sb.ToString();
        
    }
}