package api

import (
	"fmt"
	"github.com/neel1996/gitcthulu-server/global"
	"github.com/neel1996/gitcthulu-server/graph/model"
	"runtime"
)

func getOs() string {
	return runtime.GOOS
}

// HealthCheckApi returns the current version of git installed in the host and the platform gitcthulu is running on
func HealthCheckApi() *model.HealthCheckParams {
	currentVersion := global.GetCurrentVersion()
	platform := getOs()

	logger.Log(fmt.Sprintf("Obtained host information : %v -- %v", platform, currentVersion), global.StatusInfo)

	return &model.HealthCheckParams{
		Os:        platform,
		gitcthulu: currentVersion,
	}
}
