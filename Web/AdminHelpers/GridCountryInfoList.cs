using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.AdminHelpers {
    public static class GridCountryInfoList {
        public static string GetGridHTML (List<TblCountryInfo> items) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GridBasicListHelper.GetHeader("Порядок"));
            foreach (TblCountryInfo itm in items) {
                sb.Append(GridBasicListHelper.GetFormattedRow(
                    itm.Id.ToString(), itm.Title, itm.PageOrder.ToString(), Constants.DictionaryItemCountryInfo, false, true
                    , string.Format("../../Admin/CountryInfoEdit?id={0}", itm.Id)));
            }
            sb.Append(GridBasicListHelper.GetFooter());
            return sb.ToString();
        }
    }
}
