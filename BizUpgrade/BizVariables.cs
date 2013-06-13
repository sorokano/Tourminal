using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LinqToVariables;
using System.IO;
using System.Web.Script.Serialization;

namespace BizUpgrade {
    public static class BizVariables {
        public static string GetVariableById (int id) {
            TourminalDBDataContext db = new TourminalDBDataContext();
            var q = (from p in db.TblVariables
                     where p.Id == id
                     select p).Single();
            return q.Value;
        }

        public static void UpdateRoute (int id, string value) {
            TourminalDBDataContext db = new TourminalDBDataContext();
            var item = (from p in db.TblVariables
                        where p.Id == id
                        select p).Single();
            ((TblVariables)item).Value = value;
            db.SubmitChanges();
        }
    }
}
