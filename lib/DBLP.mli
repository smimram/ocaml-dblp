(** Interface to the DBLP API. *)

(** {1 Datatypes} *)

(** An author. *)
type author =
  {
    author_name : string; (** Name. *)
    author_url : string; (** DBLP URL. *)
  }

(** A publication. *)
type publication =
  {
    publication_authors : string list; (** Author names. *)
    publication_title : string; (** Title. *)
    publication_venue : string; (** Venue (name of the conference or journal). *)
    publication_pages : string; (** Pages. *)
    publication_year : int; (** Publication year. *)
    publication_type : string; (** Publication type (Journal Articles / Conference and Workshop Papers / Informal and Other Publications / etc.). *)
    publication_key : string; (** Publication key (used in particular to generate the bibtex key). *)
    publication_doi : string; (** DOI. *)
    publication_url : string; (** DBLP URL. *)
    publication_ee : string; (** URL of electronic publication. *)
    publication_access : string; (** Type of access (open / closed). *)
    publication_bib : unit -> string; (** Retrieve bibtex. *)
  }

(** A venue. *)
type venue =
  {
    venue_name : string; (** Name. *)
    venue_acronym : string; (** Acronym. *)
    venue_type : string; (** Type (Conference or Workshop, etc.). *)
    venue_url : string; (** DBLP URL. *)
  }

(** Simple string representation of a publication. *)
val string_of_publication : publication -> string

(** {1 DBLP queries} *)

(** Find an author. *)
val author : ?hits:int -> string -> author list

(** Find a publication. *)
val publication : ?hits:int -> string -> publication list

(** Find a venue. *)
val venue : ?hits:int -> string -> venue list
