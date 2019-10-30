package main

import (
	"os"
	"testing"

	"github.com/BurntSushi/toml"
	"github.com/mreiferson/go-options"
	"github.com/nsqio/nsq/internal/test"
	"github.com/nsqio/nsq/nsqlookupd"
)

func TestConfigFlagParsing(t *testing.T) {
	opts := nsqlookupd.NewOptions()
	opts.Logger = test.NewTestLogger(t)
	flagSet := nsqlookupdFlagSet(opts)
	flagSet.Parse([]string{})

	var cfg map[string]interface{}

	f, err := os.Open("../../contrib/nsqlookupd.cfg.example")
	if err != nil {
		t.Fatalf("%s", err)
	}
	toml.DecodeReader(f, &cfg)
	// cfg.Validate()

	options.Resolve(opts, flagSet, cfg)
	nsqlookupd.New(opts)

}
