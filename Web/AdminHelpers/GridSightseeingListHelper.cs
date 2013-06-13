using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.AdminHelpers {
    public static class GridSightseeingListHelper {
        public static string GetGridSightseeingListHTML (int filterCountryId, int sortByField, bool isDesc) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GetHeader(filterCountryId));
            List<TblSightseeing> list = (filterCountryId > 0)
                ? BizSightseeing.GetSightseeingListByCountryId(filterCountryId)
                : BizSightseeing.GetSightseeingList();
            foreach (TblSightseeing item in ApplySorting(list, sortByField, isDesc)) {
                //string countryRegion = BizCountry.GetCountryById(item.CountryId.Value).Name;
                //if (item.RegionId != Constants.NoValueSelected && item.RegionId != Constants.NullValueSelected)
                //    countryRegion += ", " + BizRegion.GetRegionById(item.RegionId).Name;
                sb.Append(GetFormattedRow(item.Id.ToString()
                                            , (BizDictionary.GetSightseeingTypeList()).Where(p => p.Id == item.SightseeingTypeId).Single().Description
                                                , item.Name, BizSightseeing.GetRegionNames(item.Id), item.DateCreated.ToString()));
            }
            sb.Append(GetFooter());
            return sb.ToString();
        }

        private static List<TblSightseeing> ApplySorting (List<TblSightseeing> list, int sortByField, bool isDesc) {
            var sortedSightseeings = from p in list
                               select p;

            switch (sortByField) {
                case Constants.ColSightseeingListId:
                    sortedSightseeings = (isDesc) ? from p in list orderby p.Id descending select p
                                                : from p in list orderby p.Id ascending select p;
                    break;
                case Constants.ColSightseeingListType:
                    sortedSightseeings = (isDesc) ? from p in list orderby p.SightseeingTypeId descending select p :
                                        from p in list orderby p.SightseeingTypeId ascending select p;
                    break;
                case Constants.ColSightseeingListName:
                    sortedSightseeings = (isDesc) ? from p in list orderby p.Name descending select p :
                                        from p in list orderby p.Name ascending select p;
                    break;
                case Constants.ColSightseeingListCountryRegion:
                    sortedSightseeings = (isDesc) ? from p in list orderby p.CountryId descending select p :
                                        from p in list orderby p.CountryId ascending select p;
                    break;
                case Constants.ColSightseeingListDateCreated:
                    sortedSightseeings = (isDesc) ? from p in list orderby p.DateCreated descending select p :
                                        from p in list orderby (Convert.ToDateTime(p.DateCreated)) ascending select p;
                    break;
                default:
                    sortedSightseeings = from p in list orderby p.Id ascending select p;
                    break;
            }
            return sortedSightseeings.ToList();
        }

        private static string GetHeader (int filterCountry) {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<div id=\"admin-list\">");
            stringBuilder.Append("<table border=\"1px\" width=\"1000px\" class=\"grid-common\">");
            stringBuilder.Append("    <theader>");
            stringBuilder.Append("    <tr style=\"font-weight: bold;text-align: center;\">");
            stringBuilder.Append("        <td width=\"20px\">");
            stringBuilder.Append(string.Format(filterCountry > 0 ? "<a href='?sortBy=1&filterCountry={1}' class='sort-column'>{0}</a>" 
                                                                 : "<a href='?sortBy=1' class='sort-column'>{0}</a>", "№", filterCountry));
            stringBuilder.Append("        </td>");
            stringBuilder.Append("        <td width=\"150px\">");
            stringBuilder.Append(string.Format(filterCountry > 0 ? "<a href='?sortBy=2&filterCountry={1}' class='sort-column'>{0}</a>" 
                                                                 : "<a href='?sortBy=2' class='sort-column'>{0}</a>", "Тип достоприм.", filterCountry));
            stringBuilder.Append("        </td>");
            stringBuilder.Append("        <td width=\"370px\">");
            stringBuilder.Append(string.Format(filterCountry > 0 ? "<a href='?sortBy=3&filterCountry={1}' class='sort-column'>{0}</a>"
                                                                 : "<a href='?sortBy=3' class='sort-column'>{0}</a>", "Название", filterCountry));
            stringBuilder.Append("        </td>");
            stringBuilder.Append("        <td width=\"250px\">");
            stringBuilder.Append(string.Format(filterCountry > 0 ? "<a href='?sortBy=4&filterCountry={1}' class='sort-column'>{0}</a>"
                                                                 : "<a href='?sortBy=4' class='sort-column'>{0}</a>", "Страна, регион", filterCountry));
            stringBuilder.Append("        </td>");
            stringBuilder.Append("        <td width=\"160px\">");
            stringBuilder.Append(string.Format(filterCountry > 0 ? "<a href='?sortBy=5&filterCountry={1}' class='sort-column'>{0}</a>"
                                                                 : "<a href='?sortBy=5' class='sort-column'>{0}</a>", "Дата создания", filterCountry));
            stringBuilder.Append("        </td>");
            stringBuilder.Append("        <td width=\"10px\" style=\"text-align: center\">");
            stringBuilder.Append("        ");
            stringBuilder.Append("        </td>");
            stringBuilder.Append("        <td width=\"10px\" style=\"text-align: center\">");
            stringBuilder.Append("        ");
            stringBuilder.Append("        </td>");
            stringBuilder.Append("    </tr>");
            stringBuilder.Append("    </theader>");
            return stringBuilder.ToString();
        }

        private static string GetFooter () {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("</table>");
            stringBuilder.Append("</div>");
            return stringBuilder.ToString();
        }

        private static string GetFormattedRow (string id, string sightseeingType, string name, string countryReg, string dateCreated) {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<tr class=\"row-itemlist\">");
            stringBuilder.Append("<td>");
            stringBuilder.Append(string.Format("<a href=\"/Admin/AddSightseeing?id={0}\">{0}</a>", id));
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(sightseeingType);
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(string.Format("<a href=\"/Admin/AddSightseeing?id={0}\">{1}</a>", id, name));
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(countryReg);
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(dateCreated);
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(string.Format(
                        "<img src=\"../../Content/images/grid-edit.gif\" id=\"{0}\" alt=\"Редактировать {0}\" name=\"{1}\" class=\"img-edit\" />"
                                                , id, name));
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(string.Format(
                        "<img src=\"../../Content/images/grid-delete.gif\" id=\"{0}\" alt=\"Удалить {0}\" name=\"{1}\" class=\"img-delete\" />"
                                                , id, name));
            stringBuilder.Append("</td>");
            stringBuilder.Append("</tr>");
            return stringBuilder.ToString();
        }
    }
}