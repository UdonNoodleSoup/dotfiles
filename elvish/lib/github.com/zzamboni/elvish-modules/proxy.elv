# DO NOT EDIT THIS FILE DIRECTLY
# This is a file generated from a literate programing source file located at
# https://github.com/zzamboni/elvish-modules/blob/master/proxy.org.
# You should make any changes there and regenerate it from Emacs org-mode using C-c C-v t

use ./prompt-hooks
use str

host = ""

test = $false

notify = $true

disable-autoset = $false

env-vars = [ http_proxy https_proxy ]

fn is-set {
  eval "not-eq $E:"(take 1 $env-vars)" ''"
}

fn set-proxy [@param]{
  proxyhost = $host
  if (> (count $param) 0) {
    proxyhost = $param[0]
  }
  if (not-eq $proxyhost "") {
    each [var]{ set-env $var $host } $env-vars
  }
}

fn unset-proxy {
  each [var]{ unset-env $var } $env-vars
}

fn disable {
  disable-autoset = $true
  unset-proxy
}

fn enable {
  disable-autoset = $false
}

fn autoset [@_]{
  if (or (not $test) $disable-autoset) {
    return
  }
  if ($test) {
    if (and $host (not (eq $host ""))) {
      if (and $notify (not (is-set))) {
        echo (styled "Setting proxy "$host blue)
      }
      set-proxy
    } else {
      fail "You need to set $proxy:host to the proxy to use"
    }
  } else {
    if (and $notify (is-set)) {
      echo (styled "Unsetting proxy" blue)
    }
    unset-proxy
  }
}

fn init {
  prompt-hooks:add-before-readline $autoset~
  prompt-hooks:add-after-readline $autoset~
}

init