using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Xml;
using System.IO;
using System.Data.SqlClient;

namespace NTS_Reader_CS
{
    public partial class NTS_Reader : Form
    {
        public NTS_Reader()
        {
            InitializeComponent();
        }
        private StringBuilder sbSQL_A102Y = new StringBuilder();//보험료
        private StringBuilder sbSQL_B101Y = new StringBuilder();//의료비
        private StringBuilder sbSQL_G103Y = new StringBuilder();//신용카드 체크카드 현금영수증
        private StringBuilder sbSQL_J203Y = new StringBuilder();//장기주택저당차 입금 이자상환액
        private StringBuilder sbSQL_J101Y = new StringBuilder();//주택임차차입금 원리금상환액
        private StringBuilder sbSQL_F102Y = new StringBuilder();//연금계좌
        private StringBuilder sbSQL_L101Y = new StringBuilder();//기부금
        private StringBuilder sbSQL_C101Y = new StringBuilder();//교육비,교복구입비
        private StringBuilder sbSQL_E102Y = new StringBuilder();//연금저축
        private StringBuilder sbSQL_J301Y = new StringBuilder();//주택청약저축
        //private StringBuilder sbSQL_G207M_TEST = new StringBuilder();//현금영수증 TEST

        

        private string ConnectStr = "Server=123.142.124.141;uid=sa;pwd=hsnadmin;database=UNIERP_HSN";


        private void btnPdf_Click(object sender, EventArgs e)
        {
            OpenFileDialog fileDlg = new OpenFileDialog();

            fileDlg.Filter = "PDF Files(*.PDF)|*.PDF";
            fileDlg.Multiselect = false;

            if (fileDlg.ShowDialog() == DialogResult.OK)
            {
                txtPdf.Text = fileDlg.FileName;
                txtPass.Text = string.Empty;
                txtEuckr.Text = string.Empty;
                txtUtf8.Text = string.Empty;
            }
        }

        private void btnVerify_Click(object sender, EventArgs e)
        {
            long result = 0;
            string filePath = txtPdf.Text;        
            string strMsg = string.Empty;
            
            byte[] baGenTime = new byte[1024];
            byte[] baHashAlg = new byte[1024];
            byte[] baHashVal = new byte[1024];
            byte[] baCertDN = new byte[1024];

            result = TstUtil.DSTSPdfSigVerifyF(filePath, baGenTime, baHashAlg, baHashVal, baCertDN);


            String sGenTimeTemp = Encoding.Unicode.GetString(baGenTime);
            String sHashAlgTemp = Encoding.Unicode.GetString(baHashAlg);
            String sHashValTemp = Encoding.Unicode.GetString(baHashVal);
            String sCertDNTemp = Encoding.Unicode.GetString(baCertDN);

            String sGenTime = sGenTimeTemp.Replace('\0', ' ').Trim();
            String sHashAlg = sHashAlgTemp.Replace('\0', ' ').Trim();
            String sHashVal = sHashValTemp.Replace('\0', ' ').Trim();
            String sCertDN = sCertDNTemp.Replace('\0', ' ').Trim();

            switch (result)
            {
                case 0:
                    strMsg = String.Format("원본 파일입니다. \n\nTS시각: {0} \n해쉬알고리즘: {1} \n해쉬값: {2} \nTSA인증서: {3}", sGenTime, sHashAlg, sHashVal, sCertDN);
                    break;
                case 2101:
                    strMsg = String.Format("문서가 변조되었습니다.");
                    break;
                case 2102:
                    strMsg = String.Format("TSA 서명 검증에 실패하였습니다.");
                    break;
                case 2103:
                    strMsg = String.Format("지원하지 않는 해쉬알고리즘 입니다.");
                    break;
                case 2104:
                    strMsg = String.Format("해당 파일을 읽을 수 없습니다.");
                    break;
                case 2105:
                    strMsg = String.Format("서명검증을 위한 API 처리 오류입니다.");
                    break;
                case 2106:
                    strMsg = String.Format("타임스탬프 토큰 데이터 파싱 오류입니다.");
                    break;
                case 2107:
                    strMsg = String.Format("TSA 인증서 처리 오류입니다.");
                    break;
                case 2108:
                    strMsg = String.Format("타임스탬프가 적용되지 않은 파일입니다.");
                    break;
                case 2109:
                    strMsg = String.Format("인증서 검증에 실패 하였습니다.");
                    break;
                default:
                    strMsg = String.Format("에러코드 미정의 error - [%d]", result);
                    break;
            } 
            

            MessageBox.Show(strMsg);
        }

        /// <summary>
        /// UTF-8 버튼 클릭 이벤트 : PDF 파일 내용을 UTF-8로 변환
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnUtf8_Click(object sender, EventArgs e)
        {
            string filePath = txtPdf.Text;
            string password = txtPass.Text;
            string strXML = "XML";

            if(string.IsNullOrEmpty(filePath))
            {
                return;
            }

            int fileSize = EXPFile.NTS_GetFileSize(filePath,  password, strXML, 0);

            if (fileSize > 0)
	        {
                byte[] buf = new byte[fileSize];
		        fileSize = EXPFile.NTS_GetFileBuf( filePath,  password, strXML, buf, 0);
		        if (fileSize > 0)
		        {
                    string strBuf = Encoding.UTF8.GetString(buf);
                    strBuf.Replace("\n", "\r\n");
                    txtUtf8.Text = strBuf;
		        }
            }
             
            if (fileSize == -10)
            {
                MessageBox.Show("파일이 없거나 손상된 PDF 파일입니다.");
            }
            else if (fileSize == -11)
            {
                MessageBox.Show("국세청에서 발급된 전자문서가 아닙니다.");
            }
            else if (fileSize == -13)
            {
                MessageBox.Show("추출용 버퍼가 유효하지 않습니다.");
            }
            else if (fileSize == -200)
            {
                MessageBox.Show("비밀번호가 틀립니다.");
            }
        }

        /// <summary>
        /// EUC-KR 버튼 클릭 이벤트 : PDF 파일 내용을 EUC-KR로 변환
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnEuckr_Click(object sender, EventArgs e)
        {
            int euckr = 51949;                  // EUC-KR 인코딩 값
            string filePath = txtPdf.Text;
            string password = txtPass.Text;
            string strXML = "XML";

            if (string.IsNullOrEmpty(filePath))
            {
                return;
            }

            try
            {
                int fileSize = EXPFile.NTS_GetFileSize(filePath, password, strXML, 1);
                if (fileSize > 0)
                {
                    byte[] buf = new byte[fileSize];
                    fileSize = EXPFile.NTS_GetFileBuf(filePath, password, strXML, buf, 1);
                    if (fileSize > 0)
                    {
                        string strBuf = Encoding.GetEncoding(euckr).GetString(buf);
                        strBuf.Replace("\n", "\r\n");
                        txtEuckr.Text = strBuf;
                    }
                }

                if (fileSize == -10)
                {
                    MessageBox.Show("파일이 없거나 손상된 PDF 파일입니다.");
                }
                else if (fileSize == -11)
                {
                    MessageBox.Show("국세청에서 발급된 전자문서가 아닙니다.");
                }
                else if (fileSize == -13)
                {
                    MessageBox.Show("추출용 버퍼가 유효하지 않습니다.");
                }
                else if (fileSize == -200)
                {
                    MessageBox.Show("비밀번호가 틀립니다.");
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (txtEmpNo.Text == "")
            {
                MessageBox.Show("사원번호를 입력하세요.");
                return;
            } 

            SqlDataAdapter dataAdapter = new SqlDataAdapter("EXEC USP_AUTOYESONE_UPLOAD '2020','" + txtEmpNo.Text + "'", ConnectStr);
            SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);
            DataSet ds = new DataSet();
            dataAdapter.Fill(ds);
            dataAdapter.Dispose();

            if (ds != null)
            {
                if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    MessageBox.Show(ds.Tables[0].Rows[0][0].ToString());
                    return;
                }
            }

            int euckr = 51949;                  // EUC-KR 인코딩 값
            string filePath = txtPdf.Text;
            string password = txtPass.Text;
            string strXML = "XML";

            if (string.IsNullOrEmpty(filePath))
            {
                return;
            }

            try
            {
                int fileSize = EXPFile.NTS_GetFileSize(filePath, password, strXML, 1);
                if (fileSize > 0)
                {
                    byte[] buf = new byte[fileSize];
                    fileSize = EXPFile.NTS_GetFileBuf(filePath, password, strXML, buf, 1);
                    if (fileSize > 0)
                    {
                        string strBuf = Encoding.GetEncoding(euckr).GetString(buf);
                        strBuf.Replace("\n", "\r\n");
                        txtEuckr.Text = strBuf;
                        GetXml(strBuf);
                    }
                }

                if (fileSize == -10)
                {
                    MessageBox.Show("파일이 없거나 손상된 PDF 파일입니다.");
                }
                else if (fileSize == -11)
                {
                    MessageBox.Show("국세청에서 발급된 전자문서가 아닙니다.");
                }
                else if (fileSize == -13)
                {
                    MessageBox.Show("추출용 버퍼가 유효하지 않습니다.");
                }
                else if (fileSize == -200)
                {
                    MessageBox.Show("비밀번호가 틀립니다.");
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void GetXml(string Xml)
        {
            TempDs XmlDs = new TempDs();
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(Xml.ToString());
            XmlNode NodePath = xmlDoc.ChildNodes[1];

            sbSQL_A102Y.Remove(0, sbSQL_A102Y.Length);//보험료
            sbSQL_B101Y.Remove(0, sbSQL_B101Y.Length);//의료비
            sbSQL_G103Y.Remove(0, sbSQL_G103Y.Length);//신용카드 체크카드 현금영수증
            sbSQL_J203Y.Remove(0, sbSQL_J203Y.Length);//장기주택저당차 입금 이자상환액
            sbSQL_J101Y.Remove(0, sbSQL_J101Y.Length);//주택임차차입금 원리금상환액
            sbSQL_F102Y.Remove(0, sbSQL_F102Y.Length);//연금계좌 
            sbSQL_L101Y.Remove(0, sbSQL_L101Y.Length);//기부금
            sbSQL_C101Y.Remove(0, sbSQL_C101Y.Length);//교육비,교복구입비
            sbSQL_E102Y.Remove(0, sbSQL_E102Y.Length);//연금저축
            sbSQL_J301Y.Remove(0, sbSQL_J301Y.Length);//주택청약저축
            //sbSQL_G207M_TEST.Remove(0, sbSQL_J301Y.Length);//현금영수증 TEST

            


            if (NodePath.ChildNodes.Count > 0)
            {
                for (int i1 = 0; i1 < NodePath.ChildNodes.Count; i1++)
                {
                    if (NodePath.ChildNodes[i1].Name.Equals("form"))
                    {
                        switch (NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString().ToUpper())
                        {
                            case "A102Y"://보험료
                                for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                                {
                                    sbSQL_A102Y.Append(" INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,GOODS_NM,ISNU1_RESID,INSU1_NM,TRADE_NM,BUSNID,SUM) " + '\n');
                                    for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                                    {
                                        if (i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count - 1)
                                        {
                                            sbSQL_A102Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_A102Y.Append(" 'A102Y', --구분" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + "', --보험종류" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText + "', --주피보험자주민등로번호" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText + "', --주피보험자성명" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString() + "', --상호" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString() + "', --사업자번호" + '\n');
                                            sbSQL_A102Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[9].InnerText + " UNION ALL --금액" + '\n');
                                        }
                                        else
                                        {
                                            sbSQL_A102Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_A102Y.Append(" 'A102Y', --구분" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + "', --보험종류" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText + "', --주피보험자주민등로번호" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText + "', --주피보험자성명" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString() + "', --상호" + '\n');
                                            sbSQL_A102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString() + "', --사업자번호" + '\n');
                                            sbSQL_A102Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[9].InnerText + "  --금액" + '\n');
                                        }
                                    }
                                }
                                break;
                            case "B101Y"://의료비
                                for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                                {
                                    sbSQL_B101Y.Append(" INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,SUM) " + '\n');
                                    for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                                    {
                                        if (i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count - 1)
                                        {
                                            sbSQL_B101Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_B101Y.Append(" 'B101Y', --구분" + '\n');
                                            sbSQL_B101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_B101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_B101Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + " UNION ALL --금액" + '\n');
                                        }
                                        else
                                        {
                                            sbSQL_B101Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_B101Y.Append(" 'B101Y', --구분" + '\n');
                                            sbSQL_B101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_B101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_B101Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + " --금액" + '\n');
                                        }
                                    }
                                }
                                break;
                            case "C102Y"://교육비 A:교육비 B:체험학습비
                            case "C301Y"://교복구입비
                            case "C401Y"://학자금대출 원리금상환액
                                for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                                {
                                    sbSQL_C101Y.Append(" INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,BUSNID,TRADE_NM,EDU_TP,EDU_CL,SUM) " + '\n');
                                    for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                                    {
                                        if (i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count - 1)
                                        {
                                            sbSQL_C101Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString().ToUpper() + "', --구분" + '\n');
                                            sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString() + "', --사업자번호" + '\n');
                                            sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString() + "', --상호" + '\n');
                                            if (NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString().ToUpper() == "C102Y")
                                            {
                                                sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["edu_tp"].Value.ToString() + "', --가족구분" + '\n');
                                                sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["edu_cl"].Value.ToString() + "', --교육비구분" + '\n');
                                            }
                                            else
                                            {
                                                sbSQL_C101Y.Append(" '', --가족구분" + '\n');
                                                sbSQL_C101Y.Append(" '', --교육비구분" + '\n');
                                            }
                                            sbSQL_C101Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + " UNION ALL --금액" + '\n');
                                        }
                                        else
                                        {
                                            sbSQL_C101Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString().ToUpper() + "', --구분" + '\n');
                                            sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString() + "', --사업자번호" + '\n');
                                            sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString() + "', --상호" + '\n');
                                            if (NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString().ToUpper() == "C102Y")
                                            {
                                                sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["edu_tp"].Value.ToString() + "', --가족구분" + '\n');
                                                sbSQL_C101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["edu_cl"].Value.ToString() + "', --교육비구분" + '\n');
                                            }
                                            else
                                            {
                                                sbSQL_C101Y.Append(" '', --가족구분" + '\n');
                                                sbSQL_C101Y.Append(" '', --교육비구분" + '\n');
                                            }
                                            sbSQL_C101Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + " --금액" + '\n');
                                        }
                                    }
                                }
                                break;
                            case "E102Y"://연금저축
                                for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                                {
                                    sbSQL_E102Y.Append(" INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,FUND_BANK,ACC_NO,ANN_TOT_AMT,TAX_YEAR_AMT,DDCT_BS_ASS_AMT) " + '\n');
                                    for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                                    {
                                        if (i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count - 1)
                                        {
                                            sbSQL_E102Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_E102Y.Append(" '" + NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString().ToUpper() + "', --구분" + '\n');
                                            sbSQL_E102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + "', --금융기관코드" + '\n');
                                            sbSQL_E102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString() + "', --계좌번호" + '\n');
                                            sbSQL_E102Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText + ", --당해연도납입금액" + '\n');
                                            sbSQL_E102Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText + ", --당해연도 납입액 중 인출금액" + '\n');
                                            sbSQL_E102Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[3].InnerText + " UNION ALL --순납입금액 " + '\n');
                                        }
                                        else
                                        {
                                            sbSQL_E102Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_E102Y.Append(" '" + NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString().ToUpper() + "', --구분" + '\n');
                                            sbSQL_E102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + "', --금융기관코드" + '\n');
                                            sbSQL_E102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString() + "', --계좌번호" + '\n');
                                            sbSQL_E102Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText + ", --당해연도납입금액" + '\n');
                                            sbSQL_E102Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText + ", --당해연도 납입액 중 인출금액" + '\n');
                                            sbSQL_E102Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[3].InnerText + " --순납입금액" + '\n');
                                        }
                                    }
                                }
                                break;
                            case "G107Y"://신용카드
                            case "G307Y"://체크카드
                            case "G207M"://현금영수증
                            case "G407M"://제로페이 (2019년 추가)
                                for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                                {
                                    sbSQL_G103Y.Append(" INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,USE_PLACE_CD,SUM) " + '\n');
                                    for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                                    {
                                        if (i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count - 1)
                                        {
                                            sbSQL_G103Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_G103Y.Append(" '" + NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString().ToUpper() + "', --구분" + '\n');
                                            sbSQL_G103Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_G103Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_G103Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["use_place_cd"].Value.ToString() + "', --종류" + '\n');
                                            sbSQL_G103Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + "UNION ALL --금액" + '\n');
                                            string TEST1 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText;

                                        }
                                        else
                                        {
                                            sbSQL_G103Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_G103Y.Append(" '" + NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString().ToUpper() + "', --구분" + '\n');
                                            sbSQL_G103Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_G103Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_G103Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["use_place_cd"].Value.ToString() + "', --종류" + '\n');
                                            sbSQL_G103Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + "--금액" + '\n');
                                        }
                                    }
                                }
                                break;

                                /* 월별 금액 가져오는구문 TEST
                            case "G207M"://현금영수증
                                for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                                {
                                    sbSQL_G207M_TEST.Append(" INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,USE_PLACE_CD,att_frmMM,SUM) " + '\n');
                                    for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                                    {
                                        if (i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count - 1)
                                        {
                                           for (int i4 = 1; i4 <= 12; i4++)
                                            {
                                                if (i4 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes.Count - 1)
                                                {
                                                    sbSQL_G207M_TEST.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                                    sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString().ToUpper() + "', --구분" + '\n');
                                                    sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                                    sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                                    sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["use_place_cd"].Value.ToString() + "', --종류" + '\n');
                                                    sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[i4].Attributes["mm"].Value.ToString() + "', --월" + '\n');
                                                    sbSQL_G207M_TEST.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[i4].InnerText + " UNION ALL --금액" + '\n');
 
                                                }
                                                else
                                                {
                                                    sbSQL_G207M_TEST.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                                    sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString().ToUpper() + "', --구분" + '\n');
                                                    sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                                    sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                                    sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["use_place_cd"].Value.ToString() + "', --종류" + '\n');
                                                    sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[i4].Attributes["mm"].Value.ToString() + "', --월" + '\n');
                                                    sbSQL_G207M_TEST.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[i4].InnerText + " --금액" + '\n');
                                                }
                                            }

                                        }
                                        else
                                        {//i1 pdf, i2, 쪽수, i3, 항목
                                            sbSQL_G207M_TEST.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString().ToUpper() + "', --구분" + '\n');
                                            sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_G207M_TEST.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["use_place_cd"].Value.ToString() + "', --종류" + '\n');
                                            sbSQL_G207M_TEST.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + "--금액" + '\n');
                                            string TEST1 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText;
                                            string MM = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["mm"].Value.ToString();
                                            string TEST_01 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText;
                                            string TEST_02 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText;
                                            string TEST_03 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[3].InnerText;
                                            string TEST_04 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[4].InnerText;
                                            string TEST_05 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[5].InnerText;
                                            string TEST_06 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[6].InnerText;
                                            string TEST_07 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[7].InnerText;
                                            string TEST_08 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[8].InnerText;
                                            string TEST_09 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[9].InnerText;
                                            string TEST_10 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[10].InnerText;
                                            string TEST_11 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[11].InnerText;
                                            string TEST_12 = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[12].InnerText;

                                        }
                                    }
                                }
                                break;
                                 * */
                            case "J203Y"://장기주택저당차 입금 이자상환액
                                for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                                {
                                    sbSQL_J203Y.Append(" INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,NAME,BUSNID,TRADE_NM,ACC_NO,HOUSE_TAKE_DT,MORT_SETUP_DT,START_DT,END_DT,REPAY_YEARS,LEND_GOODS_NM, ");
                                    sbSQL_J203Y.Append(" DEBT,FIXED_RATE_DEBT,NOT_DEFER_DEBT,THIS_YEAR_RADE_AMT,SUM) " + '\n');
                                    for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                                    {
                                        if (i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count - 1) /*2항목 이상 UNION ALL*/
                                        {
                                            sbSQL_J203Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_J203Y.Append(" 'J203Y', --구분" + '\n');
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');//name
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString() + "', --사업자번호" + '\n');//busnid
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString() + "', --대출명" + '\n');//trade nm 취급기관
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString() + "', --거래번호" + '\n');//acc no 계좌번호
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText + "', --주택취급일" + '\n');//house_take_dt [1] 주택취득일
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText + "', --저당권설정일" + '\n');//mort_setup_dt [2]
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[3].InnerText + "', --최초차입일" + '\n');//start_dt [3] 최초차입일
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[4].InnerText + "', --최종상환예정일" + '\n');//[4]
                                            sbSQL_J203Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[5].InnerText + ", --상환기간" + '\n');//[5]
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[6].InnerText + "', --상품명" + '\n');
                                            sbSQL_J203Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[7].InnerText + ", --차입금" + '\n');
                                            sbSQL_J203Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[8].InnerText + ", --고정금리차입금" + '\n');
                                            sbSQL_J203Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[9].InnerText + ", --비거치상환차입금" + '\n');
                                            sbSQL_J203Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[10].InnerText + ", --당해년원금상환액" + '\n');
                                            sbSQL_J203Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[11].InnerText + " UNION ALL --금액연간합계액" + '\n'); 
                                        }
                                        else
                                        {
                                            sbSQL_J203Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_J203Y.Append(" 'J203Y', --구분" + '\n');
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString() + "', --사업자번호" + '\n');
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString() + "', --대출명" + '\n');
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString() + "', --거래번호" + '\n');
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText + "', --주택취급일" + '\n');
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText + "', --저당권설정일" + '\n');
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[3].InnerText + "', --최초차입일" + '\n');
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[4].InnerText + "', --최종상환예정일" + '\n');
                                            sbSQL_J203Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[5].InnerText + ", --상환기간" + '\n');
                                            sbSQL_J203Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[6].InnerText + "', --상품명" + '\n');
                                            sbSQL_J203Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[7].InnerText + ", --차입금" + '\n');
                                            sbSQL_J203Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[8].InnerText + ", --고정금리차입금" + '\n');
                                            sbSQL_J203Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[9].InnerText + ", --비거치상환차입금" + '\n');
                                            sbSQL_J203Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[10].InnerText + ", --당해년원금상환액" + '\n');
                                            sbSQL_J203Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[11].InnerText + " --금액연간합계액" + '\n');
                                        }
                                    }
                                }
                                break;
                            case "J101Y"://주택임차차입금 원리금상환액
                                for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                                {
                                    sbSQL_J101Y.Append(" INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,NAME,BUSNID,TRADE_NM,ACC_NO,GOODS_NM,LEND_DT,SUM) " + '\n');
                                    for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                                    {
                                        if (i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count - 1)
                                        {
                                            sbSQL_J101Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_J101Y.Append(" 'J101Y', --구분" + '\n');
                                            sbSQL_J101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_J101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString() + "', --사업자번호" + '\n');
                                            sbSQL_J101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString() + "', --취급기관" + '\n');
                                            sbSQL_J101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString() + "', --대출계좌번호" + '\n');
                                            sbSQL_J101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + "', --구분" + '\n');
                                            sbSQL_J101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText + "', --대출일" + '\n');
                                            sbSQL_J101Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText + " UNION ALL --금액" + '\n');
                                        }
                                        else
                                        {
                                            sbSQL_J101Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_J101Y.Append(" 'J101Y', --구분" + '\n');
                                            sbSQL_J101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_J101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString() + "', --사업자번호" + '\n');
                                            sbSQL_J101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString() + "', --취급기관" + '\n');
                                            sbSQL_J101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString() + "', --대출계좌번호" + '\n');
                                            sbSQL_J101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + "', --구분" + '\n');
                                            sbSQL_J101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText + "', --대출일" + '\n');
                                            sbSQL_J101Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText + " --금액" + '\n');
                                        }
                                    }
                                }
                                break;
                            case "F102Y"://연금계좌
                                for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                                {
                                    sbSQL_F102Y.Append(" INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,BUSNID,PESION_CD,COM_CD,ANN_TOT_AMT) " + '\n');
                                    for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                                    {
                                        if (i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count - 1)
                                        {
                                            sbSQL_F102Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_F102Y.Append(" 'F102Y', --구분" + '\n');
                                            sbSQL_F102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString() + "', --계좌번호" + '\n');
                                            sbSQL_F102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText + "', --연금구분" + '\n');
                                            sbSQL_F102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + "', --상호코드" + '\n');
                                            sbSQL_F102Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText + " UNION ALL --금액" + '\n');
                                        }
                                        else
                                        {
                                            sbSQL_F102Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_F102Y.Append(" 'F102Y', --구분" + '\n');
                                            sbSQL_F102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString() + "', --계좌번호" + '\n');
                                            sbSQL_F102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText + "', --연금구분" + '\n');
                                            sbSQL_F102Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + "', --상호코드" + '\n');
                                            sbSQL_F102Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText + "  --금액" + '\n');
                                        }
                                    }
                                }
                                break;
                            case "L102Y"://기부금
                                for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                                {
                                    sbSQL_L101Y.Append(" INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,BUSNID,TRADE_NM,DONATION_CD,SUM) " + '\n');
                                    for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                                    {
                                        if (i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count - 1)
                                        {
                                            sbSQL_L101Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_L101Y.Append(" 'L102Y', --구분" + '\n');
                                            sbSQL_L101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_L101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_L101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString() + "', --사업자번호" + '\n');
                                            sbSQL_L101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString() + "', --단체명" + '\n');
                                            sbSQL_L101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["donation_cd"].Value.ToString() + "', --기부코드" + '\n');
                                            sbSQL_L101Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + " UNION ALL  --금액" + '\n');
                                        }
                                        else
                                        {
                                            sbSQL_L101Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_L101Y.Append(" 'L102Y', --구분" + '\n');
                                            sbSQL_L101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_L101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_L101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString() + "', --사업자번호" + '\n');
                                            sbSQL_L101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString() + "', --단체명" + '\n');
                                            sbSQL_L101Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["donation_cd"].Value.ToString() + "', --기부코드" + '\n');
                                            sbSQL_L101Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText + "  --금액" + '\n');
                                        }
                                    }
                                }
                                break;
                            case "J301Y"://주택청약저축
                                for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                                {
                                    sbSQL_J301Y.Append(" INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,BUSNID,TRADE_NM,ACC_NO,SAVING_GUBN,REG_DT,COM_CD,SUM) " + '\n');
                                    for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                                    {
                                        if (i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count - 1)
                                        {
                                            sbSQL_J301Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_J301Y.Append(" 'J301Y', --구분" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString() + "', --사업자번호" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString() + "', --단체명" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString() + "', --계좌번호" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText + "', --공제구분" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText + "', --가입일" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[3].InnerText + "', --금융기관코드" + '\n');
                                            sbSQL_J301Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[4].InnerText + " UNION ALL  --금액" + '\n');
                                        }
                                        else
                                        {
                                            sbSQL_J301Y.Append(" SELECT '" + txtEmpNo.Text + "', --사원번호" + '\n');
                                            sbSQL_J301Y.Append(" 'J301Y', --구분" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString() + "', --주민등록번호" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString() + "', --성명" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString() + "', --사업자번호" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString() + "', --단체명" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString() + "', --계좌번호" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText + "', --공제구분" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText + "', --가입일" + '\n');
                                            sbSQL_J301Y.Append(" '" + NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[3].InnerText + "', --금융기관코드" + '\n');
                                            sbSQL_J301Y.Append(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[4].InnerText + "  --금액" + '\n');
                                        }
                                    }
                                }
                                break;
                            

                        }
                        //if (NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString() == "A102Y")//보험료
                        //{
                        //    int Row = 0;
                        //    for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                        //    {
                        //        for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                        //        {
                        //            //XmlDs.INSUR.Rows.Add(XmlDs.INSUR.NewINSURRow());
                        //            //XmlDs.INSUR[Row].form_cd = "A102Y";//
                        //            //XmlDs.INSUR[Row].resid = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString();//주민등록번호
                        //            //XmlDs.INSUR[Row].name = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString();//성명
                        //            //XmlDs.INSUR[Row].busnid = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString();//사업자번호
                        //            //XmlDs.INSUR[Row].trade_nm = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString();//상호
                        //            //XmlDs.INSUR[Row].acc_no = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString();//증권번호
                        //            //XmlDs.INSUR[Row].goods_nm = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText;//보험종류
                        //            //XmlDs.INSUR[Row].insul_resid = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText;//주피보험자주민등로번호
                        //            //XmlDs.INSUR[Row].insul_nm = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText;//주피보험자성명
                        //            //XmlDs.INSUR[Row].sum = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[9].InnerText);//금액

                        //            Row++;
                        //        }
                        //    }
                        //}
                        //if (NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString() == "B101Y")//의료비
                        //{
                        //    int Row = 0;
                        //    StringBuilder sbSQL = new StringBuilder();
                        //    sbSQL.Remove(0, sbSQL.Length);
                        //    sbSQL.Append(" INSERT INTO H_HFA_TEMP_TABLE(EMP_NO,FORM_CD,RESID,NAME,SUM) " + '\n');
                        //    for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                        //    {
                        //        for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                        //        {
                        //            XmlDs.MEDICAL.Rows.Add(XmlDs.MEDICAL.NewMEDICALRow());
                        //            XmlDs.MEDICAL[Row].form_cd = "B101Y";//
                        //            XmlDs.MEDICAL[Row].resid = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString();//주민등록번호
                        //            XmlDs.MEDICAL[Row].name = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString();//성명
                        //            XmlDs.MEDICAL[Row].busnid = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString();//사업자번호
                        //            XmlDs.MEDICAL[Row].trade_nm = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString();//상호
                        //            XmlDs.MEDICAL[Row].sum = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText);//금액

                        //            Row++;
                        //        }
                        //    }
                            
                        //}
                        //if (NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString() == "G103Y")//신용카드
                        //{
                        //    int Row = 0;
                        //    for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                        //    {
                        //        for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                        //        {
                        //            XmlDs.CREDIT_CARD.Rows.Add(XmlDs.CREDIT_CARD.NewCREDIT_CARDRow());
                        //            XmlDs.CREDIT_CARD[Row].form_cd = "G103Y";//
                        //            XmlDs.CREDIT_CARD[Row].resid = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString();//주민등록번호
                        //            XmlDs.CREDIT_CARD[Row].name = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString();//성명
                        //            if (i2 == 0)
                        //            {
                        //                XmlDs.CREDIT_CARD[Row].ftyr_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["ftyr_tot_amt"].Value.ToString());//전전년도 일반
                        //                XmlDs.CREDIT_CARD[Row].ftyr_market_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["ftyr_market_tot_amt"].Value.ToString());//전전년도 전통시장
                        //                XmlDs.CREDIT_CARD[Row].ftyr_tmoney_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["ftyr_tmoney_tot_amt"].Value.ToString());//전전년도 대중교통
                        //                XmlDs.CREDIT_CARD[Row].pre_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["pre_tot_amt"].Value.ToString());//전년도 일반
                        //                XmlDs.CREDIT_CARD[Row].pre_market_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["pre_market_tot_amt"].Value.ToString());//전년도 전통시장
                        //                XmlDs.CREDIT_CARD[Row].pre_tmoney_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["pre_tmoney_tot_amt"].Value.ToString());//전년도 대중교통
                        //            }
                        //            XmlDs.CREDIT_CARD[Row].busnid = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString();//사업자번호
                        //            XmlDs.CREDIT_CARD[Row].trade_nm = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString();//상호
                        //            XmlDs.CREDIT_CARD[Row].use_place_cd = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["use_place_cd"].Value.ToString();//종류
                        //            XmlDs.CREDIT_CARD[Row].first_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["first_tot_amt"].Value.ToString());//인별상반기
                        //            XmlDs.CREDIT_CARD[Row].second_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["second_tot_amt"].Value.ToString());//인별하반기
                        //            XmlDs.CREDIT_CARD[Row].first_year_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["first_year_tot_amt"].Value.ToString());//상반기
                        //            XmlDs.CREDIT_CARD[Row].second_year_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["second_year_tot_amt"].Value.ToString());//하반기
                        //            XmlDs.CREDIT_CARD[Row].sum = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText);//금액

                        //            Row++;
                        //        }
                        //    }
                        //}
                        //if (NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString() == "G303Y")//체크카드
                        //{
                        //    int Row = 0;
                        //    for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                        //    {
                        //        for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                        //        {
                        //            XmlDs.CHECK_CARD.Rows.Add(XmlDs.CHECK_CARD.NewCHECK_CARDRow());
                        //            XmlDs.CHECK_CARD[Row].form_cd = "G303Y";//
                        //            XmlDs.CHECK_CARD[Row].resid = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString();//주민등록번호
                        //            XmlDs.CHECK_CARD[Row].name = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString();//성명
                        //            if (i2 == 0)
                        //            {
                        //                XmlDs.CHECK_CARD[Row].ftyr_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["ftyr_tot_amt"].Value.ToString());//전전년도 일반
                        //                XmlDs.CHECK_CARD[Row].ftyr_market_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["ftyr_market_tot_amt"].Value.ToString());//전전년도 전통시장
                        //                XmlDs.CHECK_CARD[Row].ftyr_tmoney_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["ftyr_tmoney_tot_amt"].Value.ToString());//전전년도 대중교통
                        //                XmlDs.CHECK_CARD[Row].pre_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["pre_tot_amt"].Value.ToString());//전년도 일반
                        //                XmlDs.CHECK_CARD[Row].pre_market_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["pre_market_tot_amt"].Value.ToString());//전년도 전통시장
                        //                XmlDs.CHECK_CARD[Row].pre_tmoney_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["pre_tmoney_tot_amt"].Value.ToString());//전년도 대중교통
                        //            }
                        //            XmlDs.CHECK_CARD[Row].busnid = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString();//사업자번호
                        //            XmlDs.CHECK_CARD[Row].trade_nm = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString();//상호
                        //            XmlDs.CHECK_CARD[Row].use_place_cd = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["use_place_cd"].Value.ToString();//종류
                        //            XmlDs.CHECK_CARD[Row].first_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["first_tot_amt"].Value.ToString());//인별상반기
                        //            XmlDs.CHECK_CARD[Row].second_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["second_tot_amt"].Value.ToString());//인별하반기
                        //            XmlDs.CHECK_CARD[Row].first_year_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["first_year_tot_amt"].Value.ToString());//상반기
                        //            XmlDs.CHECK_CARD[Row].second_year_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["second_year_tot_amt"].Value.ToString());//하반기
                        //            XmlDs.CHECK_CARD[Row].sum = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText);//금액

                        //            Row++;
                        //        }
                        //    }
                        //}
                        //if (NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString() == "G204M")//현금영수증
                        //{
                        //    int Row = 0;
                        //    for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                        //    {
                        //        for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                        //        {
                        //            XmlDs.MONEY.Rows.Add(XmlDs.MONEY.NewMONEYRow());
                        //            XmlDs.MONEY[Row].form_cd = "G204M";//
                        //            XmlDs.MONEY[Row].resid = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString();//주민등록번호
                        //            XmlDs.MONEY[Row].name = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString();//성명
                        //            if (i2 == 0)
                        //            {
                        //                XmlDs.MONEY[Row].ftyr_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["ftyr_tot_amt"].Value.ToString());//전전년도 일반
                        //                XmlDs.MONEY[Row].ftyr_market_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["ftyr_market_tot_amt"].Value.ToString());//전전년도 전통시장
                        //                XmlDs.MONEY[Row].ftyr_tmoney_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["ftyr_tmoney_tot_amt"].Value.ToString());//전전년도 대중교통
                        //                XmlDs.MONEY[Row].pre_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["pre_tot_amt"].Value.ToString());//전년도 일반
                        //                XmlDs.MONEY[Row].pre_market_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["pre_market_tot_amt"].Value.ToString());//전년도 전통시장
                        //                XmlDs.MONEY[Row].pre_tmoney_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["pre_tmoney_tot_amt"].Value.ToString());//전년도 대중교통
                        //            }
                        //            XmlDs.MONEY[Row].use_place_cd = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["use_place_cd"].Value.ToString();//종류
                        //            XmlDs.MONEY[Row].first_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["first_tot_amt"].Value.ToString());//인별상반기
                        //            XmlDs.MONEY[Row].second_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["second_tot_amt"].Value.ToString());//인별하반기
                        //            XmlDs.MONEY[Row].first_year_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["first_year_tot_amt"].Value.ToString());//상반기
                        //            XmlDs.MONEY[Row].second_year_tot_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["second_year_tot_amt"].Value.ToString());//하반기
                        //            XmlDs.MONEY[Row].sum = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText);//금액

                        //            Row++;
                        //        }
                        //    }
                        //}
                        //if (NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString() == "J203Y")//장기주택저당차 입금 이자상환액
                        //{
                        //    int Row = 0;
                        //    for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                        //    {
                        //        for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                        //        {
                        //            XmlDs.HOUSE.Rows.Add(XmlDs.HOUSE.NewHOUSERow());
                        //            XmlDs.HOUSE[Row].form_cd = "J203Y";//
                        //            XmlDs.HOUSE[Row].resid = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString();//주민등록번호
                        //            XmlDs.HOUSE[Row].name = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString();//성명
                        //            XmlDs.HOUSE[Row].busnid = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString();//사업자번호
                        //            XmlDs.HOUSE[Row].trade_nm = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString();//취급기관
                        //            XmlDs.HOUSE[Row].acc_no = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString();//번호
                        //            XmlDs.HOUSE[Row].house_take_dt = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText;//주택취급일
                        //            XmlDs.HOUSE[Row].mort_setup_dt = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText;//저당권설정일
                        //            XmlDs.HOUSE[Row].start_dt = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[3].InnerText;//최초차입일
                        //            XmlDs.HOUSE[Row].end_dt = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[4].InnerText;//최종상환예정일
                        //            XmlDs.HOUSE[Row].repay_years = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[5].InnerText);//상환기간
                        //            XmlDs.HOUSE[Row].lend_goods_nm = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[6].InnerText;//상품명
                        //            XmlDs.HOUSE[Row].debt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[7].InnerText);//차입금
                        //            XmlDs.HOUSE[Row].fixed_rate_debt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[8].InnerText);//고정금리차입금
                        //            XmlDs.HOUSE[Row].not_defer_debt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[9].InnerText);//비거치상환차입금
                        //            XmlDs.HOUSE[Row].this_year_rede_amt = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[10].InnerText);//당해년원금상환액
                        //            XmlDs.HOUSE[Row].sum = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[11].InnerText);//금액연간합계액

                        //            Row++;
                        //        }
                        //    }
                        //}
                        //if (NodePath.ChildNodes[i1].Attributes["form_cd"].Value.ToString() == "J101Y")//주택임차차입금 원리금상환액
                        //{
                        //    int Row = 0;
                        //    for (int i2 = 0; i2 < NodePath.ChildNodes[i1].ChildNodes.Count; i2++)
                        //    {
                        //        for (int i3 = 0; i3 < NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes.Count; i3++)
                        //        {
                        //            XmlDs.HOUSE2.Rows.Add(XmlDs.HOUSE2.NewHOUSE2Row());
                        //            XmlDs.HOUSE2[Row].form_cd = "J101Y";//
                        //            XmlDs.HOUSE2[Row].resid = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["resid"].Value.ToString();//주민등록번호
                        //            XmlDs.HOUSE2[Row].name = NodePath.ChildNodes[i1].ChildNodes[i2].Attributes["name"].Value.ToString();//성명
                        //            XmlDs.HOUSE2[Row].busnid = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["busnid"].Value.ToString();//사업자번호
                        //            XmlDs.HOUSE2[Row].trade_nm = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["trade_nm"].Value.ToString();//취급기관
                        //            XmlDs.HOUSE2[Row].acc_no = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].Attributes["acc_no"].Value.ToString();//대출계좌번호
                        //            XmlDs.HOUSE2[Row].goods_nm = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[0].InnerText;//구분
                        //            XmlDs.HOUSE2[Row].lend_dt = NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[1].InnerText;//대출일
                        //            XmlDs.HOUSE2[Row].sum = Convert.ToDecimal(NodePath.ChildNodes[i1].ChildNodes[i2].ChildNodes[i3].ChildNodes[2].InnerText);//금액

                        //            Row++;
                        //        }
                        //    }
                        //}
                    }
                }
                DbCommand();//DB저장및연말정산적용

            }
        }
        private void DbCommand()
        {
            if (sbSQL_A102Y.Length > 0)//보험료
            {
                sbSQL_A102Y.Append(" EXEC USP_H_UPLOAD_YEAREND_3 '2020','" + txtEmpNo.Text + "' " + '\n');
                sbSQL_A102Y.Append(" DELETE FROM H_HFA_TEMP_TABLE WHERE EMP_NO = '" + txtEmpNo.Text + "' " + '\n');
                SqlDataAdapter dataAdapter = new SqlDataAdapter(sbSQL_A102Y.ToString(), ConnectStr);
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);
                DataSet ds = new DataSet();
                dataAdapter.Fill(ds);
                dataAdapter.Dispose();
            }
            if (sbSQL_B101Y.Length > 0)//의료비
            {
                sbSQL_B101Y.Append(" EXEC USP_H_UPLOAD_YEAREND_2 '2020','" + txtEmpNo.Text + "' " + '\n');
                sbSQL_B101Y.Append(" DELETE FROM H_HFA_TEMP_TABLE WHERE EMP_NO = '" + txtEmpNo.Text + "' " + '\n');
                SqlDataAdapter dataAdapter = new SqlDataAdapter(sbSQL_B101Y.ToString(), ConnectStr);
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);
                DataSet ds = new DataSet();
                dataAdapter.Fill(ds);
                dataAdapter.Dispose();
            }
            if (sbSQL_C101Y.Length > 0)//교육비,교복구입비
            {
                sbSQL_C101Y.Append(" EXEC USP_H_UPLOAD_YEAREND_7 '2020','" + txtEmpNo.Text + "' " + '\n');
                sbSQL_C101Y.Append(" DELETE FROM H_HFA_TEMP_TABLE WHERE EMP_NO = '" + txtEmpNo.Text + "' " + '\n');
                SqlDataAdapter dataAdapter = new SqlDataAdapter(sbSQL_C101Y.ToString(), ConnectStr);
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);
                DataSet ds = new DataSet();
                dataAdapter.Fill(ds);
                dataAdapter.Dispose();
            }
            if (sbSQL_E102Y.Length > 0)//연금저축
            {
                sbSQL_E102Y.Append(" EXEC USP_H_UPLOAD_YEAREND_8 '2020','" + txtEmpNo.Text + "' " + '\n');
                sbSQL_E102Y.Append(" DELETE FROM H_HFA_TEMP_TABLE WHERE EMP_NO = '" + txtEmpNo.Text + "' " + '\n');
                SqlDataAdapter dataAdapter = new SqlDataAdapter(sbSQL_E102Y.ToString(), ConnectStr);
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);
                DataSet ds = new DataSet();
                dataAdapter.Fill(ds);
                dataAdapter.Dispose();
            }
            if (sbSQL_G103Y.Length > 0)//신용카드 체크카드 현금영수증 /*2019년 제로페이 */
            {
                sbSQL_G103Y.Append(" EXEC USP_H_UPLOAD_YEAREND2020_1 '2020','" + txtEmpNo.Text + "' " + '\n');
                sbSQL_G103Y.Append(" DELETE FROM H_HFA_TEMP_TABLE WHERE EMP_NO = '" + txtEmpNo.Text + "' " + '\n');
                SqlDataAdapter dataAdapter = new SqlDataAdapter(sbSQL_G103Y.ToString(), ConnectStr);
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);
                DataSet ds = new DataSet();
                dataAdapter.Fill(ds);
                dataAdapter.Dispose();
            }
            if (sbSQL_J203Y.Length > 0)//장기주택저당차 입금 이자상환액
            {
                sbSQL_J203Y.Append(" EXEC USP_H_UPLOAD_YEAREND_6 '2020','" + txtEmpNo.Text + "' " + '\n');
                sbSQL_J203Y.Append(" DELETE FROM H_HFA_TEMP_TABLE WHERE EMP_NO = '" + txtEmpNo.Text + "' " + '\n');
                SqlDataAdapter dataAdapter = new SqlDataAdapter(sbSQL_J203Y.ToString(), ConnectStr);
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);
                DataSet ds = new DataSet();
                dataAdapter.Fill(ds);
                dataAdapter.Dispose();
            }
            if (sbSQL_J101Y.Length > 0)//주택임차차입금 원리금상환액
            {
                sbSQL_J101Y.Append(" EXEC USP_H_UPLOAD_YEAREND '2020','" + txtEmpNo.Text + "' " + '\n');
                sbSQL_J101Y.Append(" DELETE FROM H_HFA_TEMP_TABLE WHERE EMP_NO = '" + txtEmpNo.Text + "' " + '\n');
                SqlDataAdapter dataAdapter = new SqlDataAdapter(sbSQL_J101Y.ToString(), ConnectStr);
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);
                DataSet ds = new DataSet();
                dataAdapter.Fill(ds);
                dataAdapter.Dispose();
            }
            if (sbSQL_F102Y.Length > 0)//연금계좌
            {
                sbSQL_F102Y.Append(" EXEC USP_H_UPLOAD_YEAREND_4 '2020','" + txtEmpNo.Text + "' " + '\n');
                sbSQL_F102Y.Append(" DELETE FROM H_HFA_TEMP_TABLE WHERE EMP_NO = '" + txtEmpNo.Text + "' " + '\n');
                SqlDataAdapter dataAdapter = new SqlDataAdapter(sbSQL_F102Y.ToString(), ConnectStr);
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);
                DataSet ds = new DataSet();
                dataAdapter.Fill(ds);
                dataAdapter.Dispose();
            }
            if (sbSQL_L101Y.Length > 0)//기부금
            {
                sbSQL_L101Y.Append(" EXEC USP_H_UPLOAD_YEAREND_5 '2020','" + txtEmpNo.Text + "' " + '\n');
                sbSQL_L101Y.Append(" DELETE FROM H_HFA_TEMP_TABLE WHERE EMP_NO = '" + txtEmpNo.Text + "' " + '\n');
                SqlDataAdapter dataAdapter = new SqlDataAdapter(sbSQL_L101Y.ToString(), ConnectStr);
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);
                DataSet ds = new DataSet();
                dataAdapter.Fill(ds);
                dataAdapter.Dispose();
            }
            if (sbSQL_J301Y.Length > 0)//주택청약저축
            {
                sbSQL_J301Y.Append(" EXEC USP_H_UPLOAD_YEAREND_9 '2020','" + txtEmpNo.Text + "' " + '\n');
                sbSQL_J301Y.Append(" DELETE FROM H_HFA_TEMP_TABLE WHERE EMP_NO = '" + txtEmpNo.Text + "' " + '\n');
                SqlDataAdapter dataAdapter = new SqlDataAdapter(sbSQL_J301Y.ToString(), ConnectStr);
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);
                DataSet ds = new DataSet();
                dataAdapter.Fill(ds);
                dataAdapter.Dispose();
            }

            MessageBox.Show("업로드 완료!!");
        }
    }
}
