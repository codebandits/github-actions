import * as fs from 'fs'
import * as core from '@actions/core'
import * as dotenv from 'dotenv'

export const main = () => {
    try {
        const envFile = core.getInput('path')

        if (!fs.existsSync(envFile)) {
            core.error(`The path ${envFile} did not resolve.`)
            core.setFailed(`The file '${envFile}' was not found.`)
            return
        }

        const env = dotenv.parse(fs.readFileSync(envFile))

        for (const key in env) {
            const value = env[key]
            core.setOutput(key, value)
        }
    } catch (error) {
        core.setFailed(error.message)
    }
}
