package main
//检查域名证书的时间
import (
	"crypto/tls"
	"fmt"
	"net/http"
	"time"
)

func main() {
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
	}
	client := &http.Client{Transport: tr}

	//https://dgnew86.com
	seedUrl := "https://dg168new.com"
	resp, err := client.Get(seedUrl)
	defer resp.Body.Close()

	if err != nil {
		fmt.Errorf(seedUrl, " 请求失败")
		panic(err)
	}

	//fmt.Println(resp.TLS.PeerCertificates[0])
	certInfo := resp.TLS.PeerCertificates[0]
	fmt.Println("过期时间:", certInfo.NotAfter)
	fmt.Println("组织信息:", certInfo.Subject)
	fmt.Println("证书包含的域名",certInfo.DNSNames)
	t1:=time.Now()

	fmt.Println(certInfo.DNSNames,"证书剩余天数", certInfo.NotAfter.Sub(t1).Hours()/24)
}
