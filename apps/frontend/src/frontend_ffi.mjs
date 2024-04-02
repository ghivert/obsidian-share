import { initializeApp } from 'firebase/app'
import * as authenticate from 'firebase/auth'
import { config } from './config'

let app_
let auth_

function initialize() {
  app_ ??= initializeApp(config)
  return app_
}

export function auth() {
  auth_ ??= authenticate.getAuth(initialize())
  return auth_
}

export function createUserWithEmailAndPassword(auth, email, password) {
  return authenticate.createUserWithEmailAndPassword(auth, email, password)
}

export function signInWithEmailAndPassword(auth, email, password) {
  return authenticate.signInWithEmailAndPassword(auth, email, password)
}
