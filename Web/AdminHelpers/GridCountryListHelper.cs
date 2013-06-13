using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.AdminHelpers {
    public static class GridCountryListHelper {
        public static string GetGridHTML (List<TblCountry> items) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GridBasicListHelper.GetHeader("Кол-во регионов"));
            foreach (TblCountry itm in items) {
                sb.Append(GridBasicListHelper.GetFormattedRow(
                    itm.Id.ToString(), itm.Name, DictionaryHelper.GetDistrictListData(itm.Id).Count().ToString(), Constants.DictionaryItemCountry
                    , string.Format("../../Admin/CountryEdit?id={0}", itm.Id)));
            }
            sb.Append(GridBasicListHelper.GetFooter());
            return sb.ToString();
        }
    }
}