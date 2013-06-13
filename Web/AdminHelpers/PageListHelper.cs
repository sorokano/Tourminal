using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using ElcondorBiz;
using LinqToElcondor;

namespace Elcondor.AdminHelpers {
    public static class PageListHelper {
        public static string GetListHTML () {
            StringBuilder sb = new StringBuilder();
            sb.Append("<ul>");
            foreach (TblPage item in BizDictionary.GetPageList()) {
                sb.Append(string.Format("<li style=\"list-style: none;display: inline;float: left;margin-left:30px;\"><a href=\"../../Admin/PageList?id={0}\">{1}</a></li>", item.Id, item.Title));
            }
            sb.Append("</ul>");
            return sb.ToString();
        }
    }
}