using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;
using Elcondor.UI.Utilities;

namespace Elcondor.AdminHelpers {
    public static class GridCityListHelper {
        public static string GetGridHTML (List<TblCity> items) {
            StringBuilder sb = new StringBuilder();
            sb.Append(GridBasicListHelper.GetHeader(false));
            foreach (TblCity itm in items) {
                TblCity capital = BizCity.GetCapitalCity(itm.CountryId);
                sb.Append(GridBasicListHelper.GetFormattedRow(itm.Id.ToString(), (capital != null && capital.Id == itm.Id) ? "<b>Столица: " + itm.Name + "</b>" : itm.Name
                                                                , string.Empty, Constants.DictionaryItemCity, string.Format("../../Admin/CityEdit?id={0}", itm.Id)));
            }
            sb.Append(GridBasicListHelper.GetFooter());
            return sb.ToString();
        }
    }
}