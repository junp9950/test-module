variable "region" {
  type = string
  #default = "ap-northeast-2"
}

variable "cidr_main" {
  type = string
  #default = "10.0.0.0/16"
}

variable "name" {
  type = string
  #default = "jwshin"
}

variable "cidr_public" {
    type = list(string)
    #default = [ "10.0.0.0/24","10.0.2.0/24" ]
}

variable "cidr_private" {
    type = list(string)
    #default = [ "10.0.1.0/24","10.0.3.0/24" ]  
}

variable "cidr_privatedb" {
    type = list(string)
    #default = [ "10.0.4.0/24","10.0.5.0/24" ]
  
}

variable "ava" {
    type = list(string)
    #default = ["a","c"]
  
}

variable "port_ssh" {
  type = number
  #default = 22
  
}

variable "port_http" {
  type = number
  #default = 80
  
}

variable "port_sql" {
  type = number
  #default = 3306
}

variable "cidr" {
  type = string
  #default = "0.0.0.0/0"
  
}

variable "cidr_ipv6" {
  type = string
  #default = "::/0"
  
}

variable "protocol" {
  type = string
  #default = "HTTP"
  
}