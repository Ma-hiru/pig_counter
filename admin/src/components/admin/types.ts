export type Notice = {
  type: "success" | "error" | "info";
  text: string;
};

export type AdminView = "master" | "task" | "review" | "report";
