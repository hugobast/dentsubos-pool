#include "socketapp.h"
#include "uip.h"
#include <Arduino.h>
#include <string.h>

extern char socket_response[25];

static int handle_connection(struct socket_app_state *s);

void socket_app_init(void) {
  /* Listen for connections on TCP port 9999. */
  uip_listen(HTONS(8805));
}

void socket_app_appcall(void) {
  struct socket_app_state *s = &(uip_conn->appstate);

  if(uip_connected()) {
    PSOCK_INIT(&s->p, s->inputbuffer, sizeof(s->inputbuffer));
  }

  handle_connection(s);
}

static int handle_connection(struct socket_app_state *s)
{
  PSOCK_BEGIN(&s->p);
  PSOCK_SEND_STR(&s->p, socket_response);

  PSOCK_CLOSE(&s->p);
  PSOCK_END(&s->p);
}
