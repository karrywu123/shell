package api

import (
    "net/http"
    "net/url"
    //"crypto/md5"
    "io/ioutil"
    "common"
    //"fmt"
    //"strconv"
    "encoding/json"
    //"reflect"
    //"strings"
)

type Dnspod_res struct {
    Status Res_status `json:"status"`
    Domain Res_domain `json:"domain"`
    Info Res_info `json:"info"`
    Records []Res_records `json:"records"`
}

type Res_status struct {
    Code string `json:"code"`
    Message string `json:"message"`
    Created_at string `json:"created_at"`
}

type Res_domain struct {
    Id string `json:"id"`
    Name string `json:"name"`
    Punycode string `json:"punycode"`
    Grade string `json:"grade"`
    Owner string `json:"owner"`
    Ext_status string `json:"ext_status"`
    Ttl int `json:"ttl"`
    Min_ttl int `json:"min_ttl"`
    Dnspod_ns []string `json:"dnspod_ns"`

}

type Res_info struct {
    Sub_domains string `json:"sub_domains"`
    Record_total string `json:"record_total"`
}

type Res_records struct {
    Id string `json:"id"`
    Ttl string `json:"ttl"`
    Value string `json:"value"`
    Enabled string `json:"enabled"`
    Status string `json:"status"`
    Updated_on string `json:"updated_on"`
    Name string `json:"name"`
    Line string `json:"line"`
    Line_id string `json:"line_id"`
    Type string `json:"type"`
    Weight string `json:"weight"`
    Monitor_status string `json:"monitor_status"`
    Remark string `json:"remark"`
    Use_aqb string `json:"use_aqb"`
    Mx string `json:"mx"`
    Hold string `json:"hold"`
}

//增加记录
func Add_record(domain string ,sub_domain string,record_type string,value string,status0 string) (status int, err error) {
    var res_status Dnspod_res
    status = 0
    urls := "https://dnsapi.cn/Record.Create"
    values := url.Values{"login_token":{common.Cfg.Dnspod.Login_token},"format":{common.Cfg.Dnspod.Format},"lang":{common.Cfg.Dnspod.Lang},"error_on_empty":{common.Cfg.Dnspod.Error_on_empty},"domain":{domain},"sub_domain":{sub_domain},"record_type":{record_type},"value":{value},"record_line":{"默认"},"status":{status0}}
    resp, err := http.PostForm(urls,values)
    if err == nil {
        res,_ := ioutil.ReadAll(resp.Body)
        resp.Body.Close()
        if err := json.Unmarshal([]byte(res),&res_status); err == nil {
            if res_status.Status.Code == "1" {
                status = 1
            }
        }
    }

    return
}

//删除记录
func Del_record(domain string,record string,value string) (status int, err error) {
    var res_status Dnspod_res
    status = 0
    urls := "https://dnsapi.cn/Record.Remove"
    id,err := Select_record_id(domain,record,value)
    if err == nil {
        values := url.Values{"login_token":{common.Cfg.Dnspod.Login_token},"format":{common.Cfg.Dnspod.Format},"lang":{common.Cfg.Dnspod.Lang},"error_on_empty":{common.Cfg.Dnspod.Error_on_empty},"domain":{domain},"record_id":{id}}
        resp, err := http.PostForm(urls,values)
        if err == nil {
            res,_ := ioutil.ReadAll(resp.Body)
            resp.Body.Close()
            if err := json.Unmarshal([]byte(res),&res_status); err == nil {
                if res_status.Status.Code == "1" {
                    status = 1
                }
            }
        }
    }

    return
}

//查询站点所有记录信息
func Select_record_info(domain string) (res []byte, err error){
    urls := "https://dnsapi.cn/Record.List"
    values := url.Values{"login_token":{common.Cfg.Dnspod.Login_token},"format":{common.Cfg.Dnspod.Format},"lang":{common.Cfg.Dnspod.Lang},"error_on_empty":{common.Cfg.Dnspod.Error_on_empty},"domain":{domain}}
    resp, err := http.PostForm(urls,values)
    if err == nil {
        res,err = ioutil.ReadAll(resp.Body)
        resp.Body.Close()
    }

    return
}

//获取站点某记录的id
func Select_record_id(domain string, record string, value string) (id string, err error) {
    var records Dnspod_res
    res0,err := Select_record_info(domain)
    if err == nil {
        if err := json.Unmarshal([]byte(res0),&records); err == nil {
            if records.Status.Code == "1" {
                for _,values := range records.Records {
                    if values.Value == value {
                        if values.Name == record {
                        id = values.Id
                        break
                        }
                    }
                }

            }
        } 
    }
    return
}

//改变解析记录是否开启,status:enable|disable
func Set_record_status(domain string ,record_id string,status0 string) (status int, err error) {
    var res_status Dnspod_res
    status = 0
    urls := "https://dnsapi.cn/Record.Status"
    values := url.Values{"login_token":{common.Cfg.Dnspod.Login_token},"format":{common.Cfg.Dnspod.Format},"lang":{common.Cfg.Dnspod.Lang},"error_on_empty":{common.Cfg.Dnspod.Error_on_empty},"domain":{domain},"record_id":{record_id},"status":{status0}}
    resp, err := http.PostForm(urls,values)
    if err == nil {
        res,_ := ioutil.ReadAll(resp.Body)
        resp.Body.Close()
        if err := json.Unmarshal([]byte(res),&res_status); err == nil {
            if res_status.Status.Code == "1" {
                status = 1
            }
        }
    }

    return
}
