using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.AdminHelpers {
    public static class GridExcursListHelper {
        public static string GetGridHTML (int filterCountryId, int sortByField, bool isDesc) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GetHeader(filterCountryId));
            List<TblTour> list = (filterCountryId > 0)
                ? BizTour.GetExcursListByCountryId(filterCountryId)
                : BizTour.GetExcursListByCountryId(null);
            foreach (TblTour item in ApplySorting(list, sortByField, isDesc)) {
                StringBuilder regCountryNames = new StringBuilder();
                List<TblRegion> regList = BizTour.GetTourRegionList(item.Id);
                if (regList.Count > 0) {
                    regCountryNames.Append(string.Format("{0}: ", BizCountry.GetCountryById(regList[0].CountryId).Name));
                    foreach (TblRegion reg in regList) {
                        regCountryNames.Append(string.Format("{0}, ", reg.Name));
                    }
                }
                string countryRegNames = regCountryNames.Length > 0 ? regCountryNames.ToString().Substring(0, regCountryNames.Length - 2) : regCountryNames.ToString();
                sb.Append(GetFormattedRow(item.Id.ToString(), item.Name, countryRegNames));
            }
            sb.Append(GetFooter());
            return sb.ToString();
        }

        private static List<TblTour> ApplySorting (List<TblTour> list, int sortByField, bool isDesc) {
            var sortedExcurss = from p in list
                              select p;

            switch (sortByField) {
                case Constants.ColTourListId:
                    sortedExcurss = (isDesc) ? from p in list orderby p.Id descending select p
                                                : from p in list orderby p.Id ascending select p;
                    break;
                case Constants.ColTourListName:
                    sortedExcurss = (isDesc) ? from p in list orderby p.Name descending select p :
                                        from p in list orderby p.Name ascending select p;
                    break;
                //case Constants.ColTourListCountry:
                //    sortedExcurss = (isDesc) ? from p in list orderby p.RegionId descending select p :
                //                        from p in list orderby p.RegionId ascending select p;
                //    break;
                default:
                    sortedExcurss = from p in list orderby p.Id ascending select p;
                    break;
            }
            return sortedExcurss.ToList();
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
                                                                 : "<a href='?sortBy=2' class='sort-column'>{0}</a>", "Название", filterCountry));
            stringBuilder.Append("        </td>");
            stringBuilder.Append("        <td width=\"250px\">");
            stringBuilder.Append(string.Format("Страна, регион", filterCountry));
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

        private static string GetFormattedRow (string id, string name, string countryReg) {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<tr class=\"row-itemlist\">");
            stringBuilder.Append("<td>");
            stringBuilder.Append(string.Format("<a href=\"/Admin/ExcursEdit?id={0}\">{0}</a>", id));
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(string.Format("<a href=\"/Admin/ExcursEdit?id={0}\">{1}</a>", id, name));
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(countryReg);
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