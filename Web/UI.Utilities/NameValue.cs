using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Threading;
using System.Text;
using LinqToElcondor;
using System.IO;
using System.Drawing;
using Elcondor.Models;

namespace Elcondor {

    public class NameValue {
        public string name { get; set; }
        public string value { get; set; }

        public NameValue(string nameVal, string valueVal) {
            name = nameVal;
            value = valueVal;
        }
    }

    /// <summary>
    /// Simple NameValue class that maps name and value
    /// properties that can be used with jQuery's 
    /// $.serializeArray() function and JSON requests
    /// </summary>

    public static class NameValueExtensionMethods {
        public static string Form(this NameValue[] formVars, string name) {
            var matches = formVars.FirstOrDefault(nv => string.Equals(nv.name, name, StringComparison.OrdinalIgnoreCase));
            return (null != matches) ? matches.value : string.Empty;
        }

        public static string[] FormMultiple(this  NameValue[] formVars, string name) {
            var matches = formVars.Where(nv => string.Equals(nv.name, name, StringComparison.OrdinalIgnoreCase)).Select(nv => nv.value).ToArray();
            return (0 == matches.Length) ? null : matches;
        }

    }
}