//
// Sharp Content Portal - http://www.SharpContentPortal.com
// Copyright (c) 2002-2006
// by Perpetual Motion Interactive Systems Inc. ( http://www.perpetualmotion.ca )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and 
// to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions 
// of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
// TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
//
// File Author(s):
// Mauricio Márquez Anze - http://dnn.tiendaboliviana.com
//
// FCKeditor - The text editor for internet - http://www.fckeditor.net
// Copyright (C) 2003-2006 Frederico Caldeira Knabben
//

using System;
using System.Drawing;
using System.Text;
namespace SharpContent.HtmlEditor.FckHtmlEditorProvider
{


	public enum FCKObjectType : int
	{
		FCKUpFolder = 1,
		FCKnormalFolder = 2,
		FCKImage = 3,
		FCKFlash = 4
	}

	public class FckGalleryObject
	{
		private FCKObjectType _type;
		private string _Name;
		private int _Width;
		private int _Height;
		private long _FileSize;
		private string _ClientPath;
		private string _FileName;


		public FCKObjectType FCKType {
			get { return _type; }
			set { _type = value; }
		}

		public string FCKName {
			get { return _Name; }
			set { _Name = value; }
		}

		public int FCKWidth {
			get { return _Width; }
			set { _Width = value; }
		}

		public int FCKHeight {
			get { return _Height; }
			set { _Height = value; }
		}

		public string ClientPath {
			get { return _ClientPath; }
			set { _ClientPath = value; }
		}

         public string _ServerPath
         {
             get { return null; }
         }

		public string FileName {
			get { return _FileName; }
			set { _FileName = value; }
		}

		public int FCKThumbHeight {
			get {
				int h;
				if (_Height >= _Width)
				{
					if (_Height > 100)
					{
						h = 100;
					}
					else
					{
						h = _Height;
					}
				}
				else
				{
					h = (int)100 * _Height / _Width;
				}
				return h;
			}
		}

		public int FCKThumbWidth {
			get {
				int w;
				if (_Width >= _Height)
				{
					if (_Width > 100)
					{
						w = 100;
					}
					else
					{
						w = _Width;
					}
				}
				else
				{
					w = (int)100 * _Width / _Height;
				}
				return w;
			}
		}

		public long FCKFileSize {
			get { return _FileSize; }
			set { _FileSize = value; }
		}

		public string ServerFile {
			get { return System.Web.HttpContext.Current.Server.MapPath(ClientPath + FileName); }
		}
	}


	public class FCKNormalFolderObject : FckGalleryObject
	{

		public FCKNormalFolderObject(FckGalleryBase pParent, string pDisplayName)
		{
			this.FCKType = FCKObjectType.FCKnormalFolder;
			this.FileName = pParent.GetFCKTemplateValue("FolderDn.Image", pParent.Theme, pParent.GalleryType);
			string strCP = pParent.TemplateSourceDirectory + "/FCKTemplates/" + pParent.GalleryType + "Browser/" + pParent.Theme + "/";

			this.ClientPath = strCP;
			Image fi = Image.FromFile(ServerFile);
			FCKHeight = fi.Height;
			FCKWidth = fi.Width;
			this.FCKName = pDisplayName;

		}
	}

	public class FCKUpFolderObject : FckGalleryObject
	{

		public FCKUpFolderObject(FckGalleryBase pParent, string pDisplayName)
		{
			this.FCKType = FCKObjectType.FCKUpFolder;
			this.FileName = pParent.GetFCKTemplateValue("FolderUp.Image", pParent.Theme, pParent.GalleryType);
			string strCP = pParent.TemplateSourceDirectory + "/FCKTemplates/" + pParent.GalleryType + "Browser/" + pParent.Theme + "/";

			this.ClientPath = strCP;
			//Me.ClientPath = pParent.TemplateSourceDirectory & "/FCKTemplates/" & pParent.GalleryType & "Browser/" & pParent.Theme & "/"
			Image im = Image.FromFile(ServerFile);
			FCKHeight = im.Height;
			FCKWidth = im.Width;
			im.Dispose();
			this.FCKName = pDisplayName;

		}
	}

	public class FCKImageObject : FckGalleryObject
	{

		public FCKImageObject(FckGalleryBase pParent, string pClientPath, string pFilename, string pDisplayName)
		{
			this.FCKType = FCKObjectType.FCKImage;
			this.FileName = pFilename;
			this.ClientPath = pClientPath;
			Image image = null;
			try 
               {
                   image = Image.FromFile(ServerFile);
                   FCKHeight = image.Height;
                   FCKWidth = image.Width;
			}
			catch (Exception ex) {
			}

               if (image != null)
			{
                   image.Dispose();
			}

			this.FCKName = pDisplayName;
			System.IO.FileInfo finfo = new System.IO.FileInfo(ServerFile);
			FCKFileSize = finfo.Length;
		}

	}

	public class FCKFlashObject : FckGalleryObject
	{

		private SWFDump _FlashInfo;

		public FCKFlashObject(FckGalleryBase pParent, string pClientPath, string pFilename, string pDisplayName)
		{
			this.FCKType = FCKObjectType.FCKFlash;
			this.FileName = pFilename;
			this.ClientPath = pClientPath;
			this.FCKName = pDisplayName;

			SWFDump objswf = new SWFDump();
			objswf.GetInfo(ServerFile);
			FCKHeight = objswf.Heigt;
			FCKWidth = objswf.Width;
			_FlashInfo = objswf;
			System.IO.FileInfo finfo = new System.IO.FileInfo(ServerFile);
			FCKFileSize = finfo.Length;

		}

		public object FlashInfo {
			get { return _FlashInfo; }
		}
	}

    public class SWFDump
    {

        private string header;
        private string RECTdata;
        private int nBits;
        private string mversion;
        private int mfilelen;
        private int mxMin;
        private int mxMax;
        private int myMin;
        private int myMax;
        private int mheigt;
        private int mwidth;
        private int mframerate;
        private int mframecount;

        private string ReadHeader(string filename)
        {
            System.IO.FileStream f = System.IO.File.OpenRead(filename);
            byte[] buf = new byte[31];
            f.Read(buf, 0, 21);

            f.Close();
            string str = String.Empty;
            for (int i = 0; i <= 20; i++)
            {
                str += Convert.ToChar(buf[i]);
            }
            return str;
        }

        private string ToBin(int inNumber, int outLenStr)
        {
            string binary;
            binary = "";
            while (inNumber >= 1)
            {
                binary = binary + (inNumber % 2).ToString();
                inNumber = inNumber / 2;
            }
            binary = binary + new string('0', outLenStr - binary.Length);
            return StringReverse(binary);
        }

        private string StringReverse(string ToReverse)
        {
            Array arr = ToReverse.ToCharArray();
            Array.Reverse(arr); // reverse the string
            char[] c = (char[])arr;
            return (new string(c));
        }

        private int Bin2Decimal(string inBin)
        {

            int value = 0;
            inBin = StringReverse(inBin);
            int temp = 0;
            for (int counter = 1; counter <= inBin.Length; counter++)
            {
                if (counter == 1)
                {
                    value = 1;
                }
                else
                {
                    value = value * 2;
                }
                temp = temp + Convert.ToInt32(inBin.Substring(counter, 1)) * value;
            }
            return temp;
        }

        public void GetInfo(string fileName)
        {

            header = ReadHeader(fileName);
            mversion = Asc(header.Substring(4, 1)).ToString();
            mfilelen = Asc(header.Substring(5, 1));
            mfilelen = mfilelen + Asc(header.Substring(6, 1)) * 256;
            mfilelen = mfilelen + Asc(header.Substring(7, 1)) * 256 * 256;
            mfilelen = mfilelen + Asc(header.Substring(8, 1)) * 256 * 256 * 256;

            RECTdata = ToBin(Asc(header.Substring(9, 1)), 8);
            RECTdata = RECTdata + ToBin(Asc(header.Substring(10, 1)), 8);
            RECTdata = RECTdata + ToBin(Asc(header.Substring(11, 1)), 8);
            RECTdata = RECTdata + ToBin(Asc(header.Substring(12, 1)), 8);
            RECTdata = RECTdata + ToBin(Asc(header.Substring(13, 1)), 8);
            RECTdata = RECTdata + ToBin(Asc(header.Substring(14, 1)), 8);
            RECTdata = RECTdata + ToBin(Asc(header.Substring(15, 1)), 8);
            RECTdata = RECTdata + ToBin(Asc(header.Substring(16, 1)), 8);
            RECTdata = RECTdata + ToBin(Asc(header.Substring(17, 1)), 8);

            nBits = Convert.ToInt32(RECTdata.Substring(1, 5));
            nBits = Bin2Decimal(nBits.ToString());

            mxMin = Bin2Decimal(RECTdata.Substring(6, nBits));
            mxMax = Bin2Decimal(RECTdata.Substring(6 + nBits * 1, nBits));
            myMin = Bin2Decimal(RECTdata.Substring(6 + nBits * 2, nBits));
            myMax = Bin2Decimal(RECTdata.Substring(6 + nBits * 3, nBits));

            mheigt = (int)(myMax - myMin) / 20;
            mwidth = (int)(mxMax - mxMin) / 20;

            mframerate = Asc(header.Substring(18, 1));

            mframecount = Asc(header.Substring(19, 1));
            mframecount = mframecount + Asc(header.Substring(20, 1)) * 256;

        }

        private int Asc(string s)
        {
            //Return the character value of the given character
            return (int)Encoding.ASCII.GetBytes(s)[0];
        }

        public int Heigt
        {
            get { return mheigt; }
        }

        public int Width
        {
            get { return mwidth; }
        }

        public string Version
        {
            get { return mversion; }
        }

        public int FileLen
        {
            get { return mfilelen; }
        }

        public int xMin
        {
            get { return mxMin; }
        }

        public int xMax
        {
            get { return mxMax; }
        }

        public int yMin
        {
            get { return myMin; }
        }

        public int yMax
        {
            get { return myMax; }
        }


        public int Framerate
        {
            get { return mframerate; }
        }

        public int Framecount
        {
            get { return mframecount; }
        }
    }
}

