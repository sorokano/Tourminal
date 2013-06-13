using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;

namespace Elcondor.AdminHelpers {
    public static class GridBasicListHelper {
        public static string GetHeader () {
            return GetHeader(true, string.Empty);
        }

        public static string GetHeader (bool showRecordAmount) {
            return GetHeader(showRecordAmount, string.Empty);
        }

        public static string GetHeader (string amountColunmnName) {
            return GetHeader(true, amountColunmnName);
        }

        public static string GetHeader (bool showRecordAmount, string amountColunmnName) {
            amountColunmnName = string.IsNullOrEmpty(amountColunmnName) ? "Кол-во" : amountColunmnName;
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<div id=\"admin-list\">");
            stringBuilder.Append("<table border=\"1px\" width=\"500px\" class=\"grid-common\">");
            stringBuilder.Append("    <theader>");
            stringBuilder.Append("    <tr style=\"font-weight: bold;text-align: center;\">");
            stringBuilder.Append("        <td width=\"20px\">");
            stringBuilder.Append("            №");
            stringBuilder.Append("        </td>");
            stringBuilder.Append("        <td width=\"560px\">");
            stringBuilder.Append(string.Format("{0}", "Название"));
            stringBuilder.Append("        </td>");
            if (showRecordAmount) {
                stringBuilder.Append("        <td width=\"200px\">");
                stringBuilder.Append(string.Format("{0}", amountColunmnName));
                stringBuilder.Append("        </td>");
            }
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

        public static string GetFooter () {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("</table>");
            stringBuilder.Append("</div>");
            return stringBuilder.ToString();
        }

        public static string GetFormattedRow (string key, string value, string childItemsAmount, string entityName) {
            return GetFormattedRow(key, value, childItemsAmount, entityName, false, true, string.Empty);
        }

        public static string GetFormattedRow (string key, string value, string childItemsAmount, string entityName, string url) {
            return GetFormattedRow(key, value, childItemsAmount, entityName, false, true, url);
        }

        public static string GetFormattedRow (string key, string value, string childItemsAmount, string entityName, bool showchildItemsAmount) {
            return GetFormattedRow(key, value, childItemsAmount, entityName, false, showchildItemsAmount, string.Empty);
        }

        public static string GetFormattedRow (string key, string value, string childItemsAmount, string entityName, bool readOnly, bool showchildItemsAmount) {
            return GetFormattedRow(key, value, childItemsAmount, entityName, false, showchildItemsAmount, string.Empty);
        }

        public static string GetFormattedRow (string key, string value, string childItemsAmount, string entityName, bool readOnly, bool showchildItemsAmount, string url) {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<tr class=\"row-itemlist\">");
            stringBuilder.Append("<td>");
            stringBuilder.Append(key);
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(string.IsNullOrEmpty(url) ? value : string.Format("<a href=\"{0}\">{1}</a>", url, value));
            stringBuilder.Append("</td>");
            if (showchildItemsAmount) {
                stringBuilder.Append("<td>");
                stringBuilder.Append(childItemsAmount);
                stringBuilder.Append("</td>");
            }
            stringBuilder.Append("<td>");
            if (!readOnly)
                stringBuilder.Append(string.Format(
                        "<img src=\"../../Content/images/grid-edit.gif\" id=\"{0}\" alt=\"Редактировать {0}\" name=\"{1}\" class=\"img-edit\" />"
                                                , key, value));
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            if (!readOnly)
                stringBuilder.Append(string.Format(
                        "<img src=\"../../Content/images/grid-delete.gif\" id=\"{0}\" alt=\"Удалить {0}\" name=\"{1}\" class=\"img-delete\" />"
                                                , key, value));
            stringBuilder.Append("</td>");
            stringBuilder.Append("</tr>");
            return stringBuilder.ToString();
        }

        public static string GetSelectFormattedRow (string key, string value, string entityName, bool rowChecked) {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(string.Format("<tr class=\"row-itemlist-{0}\">", entityName));
            stringBuilder.Append("<td>");
            stringBuilder.Append(string.Format("<input type=\"checkbox\" id=\"{0}\" value=\"{1}\" {2} />"
                                                , key, rowChecked.ToString().ToLower()
                                                , rowChecked ? "checked=\"checked\"" : string.Empty));
            stringBuilder.Append("</td>");
            stringBuilder.Append("<td>");
            stringBuilder.Append(value);
            stringBuilder.Append("</td>");
            stringBuilder.Append("</tr>");
            return stringBuilder.ToString();
        }

        public static string GetSelectGridHeader () {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("<div id=\"admin-list\">");
            stringBuilder.Append("<table border=\"1px\" width=\"500px\" class=\"grid-common\">");
            stringBuilder.Append("    <theader>");
            stringBuilder.Append("    <tr style=\"font-weight: bold;text-align: center;\">");
            stringBuilder.Append("        <td width=\"20px\">");
            stringBuilder.Append("        </td>");
            stringBuilder.Append("        <td width=\"560px\">");
            stringBuilder.Append(string.Format("{0}", "Название"));
            stringBuilder.Append("        </td>");
            stringBuilder.Append("    </tr>");
            stringBuilder.Append("    </theader>");
            return stringBuilder.ToString();
        }
    }
}