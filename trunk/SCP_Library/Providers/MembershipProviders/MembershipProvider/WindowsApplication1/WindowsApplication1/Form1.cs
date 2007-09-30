using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
//using System.Data.OracleClient;
using Oracle.DataAccess.Client;
using Microsoft.ApplicationBlocks.Data;
using Oracle.DataAccess.Types;

namespace WindowsApplication1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            label1.Text = AspNetMembershipUpdateUser("CSharpNuke", "Admin", "test@test.com", false, "No comment!", true, DateTime.Now, DateTime.Now).ToString();
        }            

        public int AspNetMembershipUpdateUser(string i_applicationname, string i_username, string i_email, bool i_requiresuniqueemail, string i_comment, bool i_isapproved, DateTime i_lastlogindate, DateTime i_lastactivitydate)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_username", OracleDbType.NVarchar2), 
		    new OracleParameter("i_email", OracleDbType.NVarchar2), 
		    new OracleParameter("i_requiresuniqueemail", OracleDbType.Int32), 
		    new OracleParameter("i_comment", OracleDbType.NClob), 
		    new OracleParameter("i_isapproved", OracleDbType.Int32), 
		    new OracleParameter("i_lastlogindate", OracleDbType.Date), 
		    new OracleParameter("i_lastactivitydate", OracleDbType.Date),
              new OracleParameter("o_returnvalue", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_email;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_requiresuniqueemail ? 1 : 0;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = String.IsNullOrEmpty(i_comment) ? "" : i_comment;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_isapproved ? 1 : 0;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_lastlogindate;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_lastactivitydate;
            parms[8].Direction = ParameterDirection.Output;

            string ConnectionString = "Data Source=j-thomas-t60:1521/xe;Persist Security Info=True;User ID=csws_dbo;Password=Pa55w0rd;Enlist=no;Persist Security Info=no;Pooling=yes;Connection Lifetime=20;Max Pool Size=20;Min Pool Size=20";
            string DatabaseOwner = "csws_dbo.";
            string AspnetProviderPackageName = "dotnet_";

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_UPDATEUSER", parms);
            return Convert.ToInt32(parms[8].Value.ToString());
        }
    }
}