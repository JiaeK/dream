module Dream = Dream_pure.Inmost



let name =
  "dream.request_id"

let last_id =
  Dream.new_global
    (fun () -> ref 0)
    ~debug:(fun id -> "dream.request_id.last_id", string_of_int !id)

let id =
  Dream.new_local
    ()
    ~debug:(fun id -> name, id)

let lwt_key =
  Lwt.new_key ()



let assign ?(prefix = "") next_handler request =

  (* Get the last id for this request's app, increment it, and prepend the
     prefix. *)
  let last_id_ref : int ref =
    Dream.global last_id request in

  incr last_id_ref;

  let new_id =
    prefix ^ (string_of_int !last_id_ref) in

  (* Store the new id in the request and in the Lwt promise values map for
     best-effort delivery to all code that might want the id. Continue into the
     rest of the app. *)
  let request =
    Dream.with_local id new_id request in

  Lwt.with_value
    lwt_key
    (Some new_id)
    (fun () ->
      next_handler request)



let get_option ?request () =

  (* First, try to get the id from the request, if one was provided. *)
  let request_id =
    match request with
    | None -> None
    | Some request ->
      Dream.local_option id request
  in

  (* If no id was found from the maybe-request, look in the promise-chain-local
     storage. *)
  match request_id with
  | Some _ -> request_id
  | None ->
    Lwt.get lwt_key



(* TODO LATER Maybe it's better to build the request id straight into the
   runtime? There's no real cost to it... is there? And when wouldn't the user
   want a request id? *)
(* TODO LATER List arguments for built-in middlewares: 0 or so cost, highly
   beneficial, in some cases (prefix) actually necessary for correct operation
   of a website. *)
