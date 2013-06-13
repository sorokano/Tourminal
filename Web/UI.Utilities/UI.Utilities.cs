using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Globalization;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Xml.Linq;

namespace Elcondor.UI.Utilities {
    public static class UIHelper {
        public static string[] SplitByString(string testString, string split) {
            int offset = 0;
            int index = 0;
            int[] offsets = new int[testString.Length + 1];

            while (index < testString.Length) {
                int indexOf = testString.IndexOf(split, index);
                if (indexOf != -1) {
                    offsets[offset++] = indexOf;
                    index = (indexOf + split.Length);
                } else {
                    index = testString.Length;
                }
            }

            string[] final = new string[offset + 1];
            if (offset == 0) {
                final[0] = testString;
            } else {
                offset--;
                final[0] = testString.Substring(0, offsets[0]);
                for (int i = 0; i < offset; i++) {
                    final[i + 1] = testString.Substring(offsets[i] + split.Length, offsets[i + 1] - offsets[i] - split.Length);
                }
                final[offset + 1] = testString.Substring(offsets[offset] + split.Length);
            }
            return final;
        }

        public static void GetImageBytesWithExtension(HttpPostedFileBase file, out byte[] pic, int maxHeight) {
            Bitmap originalImage = new Bitmap(file.InputStream);
            int newWidth = originalImage.Width;
            int newHeight = originalImage.Height;
            double aspectRatio = (double)originalImage.Width / (double)originalImage.Height;
            if (aspectRatio > 1 && originalImage.Height > maxHeight) {
                newHeight = maxHeight;
                newWidth = (int)Math.Round(newHeight * aspectRatio);
            }
            Bitmap newImage = new Bitmap(originalImage, newWidth, newHeight);
            MemoryStream ms = new MemoryStream();
            newImage.Save(ms, ImageFormat.Jpeg);
            pic = ms.ToArray();

            //int maxImgHeight = maxHeight;
            //System.Drawing.Image img = System.Drawing.Image.FromStream(file.InputStream);
            //int origHeight = img.Height;
            //int origWidth = img.Width;
            //System.Drawing.Image imgThumb = null;
            //if (origHeight > maxImgHeight) {
            //    float heightDiffPercent = maxImgHeight * 100 / origHeight;
            //    int newWidth = (int)(origWidth * heightDiffPercent / 100);
            //    imgThumb = img.GetThumbnailImage(newWidth, maxImgHeight, null, System.IntPtr.Zero);
            //} else {
            //    imgThumb = img.GetThumbnailImage(origWidth, origHeight, null, System.IntPtr.Zero);
            //}
            //System.IO.Stream imgStream = new System.IO.MemoryStream();
            //imgThumb.Save(imgStream, System.Drawing.Imaging.ImageFormat.Jpeg);
            //pic = new byte[imgStream.Length];
            //imgStream.Seek(0, System.IO.SeekOrigin.Begin);
            //imgStream.Read(pic, 0, pic.Length);
        }

        public static void GetImageBytesWithExtension(HttpPostedFileBase file, out byte[] pic) {
            GetImageBytesWithExtension(file, out pic, 114);
        }

        public static System.Drawing.Image ByteArrayToImage(byte[] byteArrayIn) {
            MemoryStream ms = new MemoryStream(byteArrayIn);
            System.Drawing.Image returnImage = System.Drawing.Image.FromStream(ms);
            return returnImage;
        }

        public static bool CheckContainsEnglishNumbers(string charString) {
            Regex reg = new Regex(@"^[a-zA-Z'.]{1,40}$");
            return Regex.IsMatch(charString, @"^[a-zA-Z0-9_]{3,20}$");
        }

        public static bool CheckContainsNumbers(string charString) {
            Regex reg = new Regex(@"^[a-zA-Z'.]{1,40}$");
            return Regex.IsMatch(charString, "^[0-9]*$");
        }

        public static bool CheckDate(string charString) {
            try {
                Convert.ToDateTime(charString);
                return true;
            } catch {
                return false;
            }
        }

        public static T[] GetPage<T, K>(System.Data.Linq.Table<T> tableObject, System.Linq.Expressions.Expression<Func<T, K>> orderPred,
                                        int pageSize, int selectedPage) where T : class, new() {
            return tableObject.OrderByDescending(orderPred).Skip(pageSize * (selectedPage - 1)).Take(pageSize).ToArray();
        }

        public static string GetPageText (int pageId) {
            return ElcondorBiz.BizDictionary.GetPageById(pageId).Text;
        }
    }
}